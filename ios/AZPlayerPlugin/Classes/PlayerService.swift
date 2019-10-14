//
//  PlayerService.swift
//  aparnik_plugin
//
//  Created by Ali Zahedi on 9/24/19.
//  Copyright © 2019 Ali Zahedi. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import MediaPlayer
import AVFoundation
import SDWebImage

enum LoopType: String, CaseIterable{
    
    case one
    case all
    case none
    case shuffle
    
    func next() -> LoopType{
        var flag = false
        for item in LoopType.allCases{
            if flag {
                return item
            }
            if item == self{
                flag = true
            }
        }
        return .one
    }
}

protocol PlayerSetviceDelegate: class{
    
    func playFile(_ currentFile: File)
    func pauseFile(_ currentFile: File?)
}

class PlayerService: NSObject{
    
    // Mark: Static
    static var shared = PlayerService()
    
    // Mark: Public
    var looptype: LoopType{
        didSet{
            UserDefaults.standard.setValue(self.looptype.rawValue, forKey: "looptype")
            UserDefaults.standard.synchronize()
        }
    }
    weak var delegate: PlayerSetviceDelegate?
    var timeObserverToken: Any?
    
    // Total Time
    var totalTime: Double?{
        
        return player?.currentItem?.asset.duration.seconds
    }
    
    // is Playing
    var isPlaying: Bool{
        
        return self.player?.isPlaying ?? false
    }
    
    // Current Time
    var currentTime: Double?{
        let value = self.player?.currentItem?.currentTime().seconds
        return value
    }
    
    // Current File
    private(set) var currentFile: File?{
        set{
            self._currentFile = newValue
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeFilePlayLoadInMemory"), object: nil, userInfo: nil)
           
        }get{
            return self._currentFile
        }
    }
    fileprivate let coverImageView: UIImageView = UIImageView.init()
    fileprivate var _currentFile: File? {
        
        didSet{
            
//            self.updateUI()

                
            oldValue?.fileStatus = .ready
                oldValue?.currentTime = 0.0
    
        }
    }
    
    // Mark: Private
    private(set) var files: [File] = []
    fileprivate var playerLayer: AVPlayerLayer?
    fileprivate var player: AVPlayer?
    //
    fileprivate let session = AVAudioSession.sharedInstance()
    fileprivate let commandCenter = MPRemoteCommandCenter.shared()
    fileprivate let playingInfo = MPNowPlayingInfoCenter.default()
    fileprivate var imagePlaceHolderPath: URL?
    
    // Mark: Init
    private override init() {
        
        if let decodedLoop = UserDefaults.standard.object(forKey: "looptype") as? String{
            
            self.looptype = LoopType(rawValue: decodedLoop) ?? .all
        }else {
            
            self.looptype = LoopType.all
        }
        super.init()
        
        
        do{
            
            try self.session.setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
            //            try self.session.setActive(true, options: [])
        }catch{
            
            NSLog("intialize of Player service wrong with: \(error.localizedDescription)")
        }
        
        // previouse
                self.commandCenter.previousTrackCommand.isEnabled = true
                self.commandCenter.previousTrackCommand.addTarget(self, action: #selector(playBackward))
//                 next
                self.commandCenter.nextTrackCommand.isEnabled = true
                self.commandCenter.nextTrackCommand.addTarget(self, action: #selector(playNext))
        // play
        self.commandCenter.playCommand.isEnabled = true
        self.commandCenter.playCommand.addTarget(self, action: #selector(playAction))
        // pause
        self.commandCenter.pauseCommand.isEnabled = true
        self.commandCenter.pauseCommand.addTarget(self, action: #selector(pause))
        // playbackposition
        if #available(iOS 9.1, *) {
            self.commandCenter.changePlaybackPositionCommand.isEnabled = true
            self.commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(changedThumbSliderOnLockScreen(_:)))
        } else {
            // Fallback on earlier versions
        }
        
        // disable
        self.commandCenter.skipBackwardCommand.isEnabled = false
        self.commandCenter.skipForwardCommand.isEnabled = false
        
        self.coverImageView.contentMode = .scaleAspectFill
        self.coverImageView.clipsToBounds = true
    }
    
    // Mark: Function
    func configure(files: [File]) {
        
        self.stop()
        self.files = files
    }
    
    func addFileToList(file: File){
        
        self.files.append(contentsOf: [file])
    }
    
    
    func addFilesToList(files: [File]){
        
        self.files.append(contentsOf: files)
    }
    // Change Current Time
    func changeCurrentTime(secend: Double, timeScale: Int=1000){
        
        let scale = CMTimeScale(timeScale)
        let time: CMTime = CMTime(seconds: secend, preferredTimescale: scale)
        player?.seek(to: time)
    }
    
    
    // stop
    func stop(_ sender: AnyObject){
        
        self.stop()
    }
    
    // Pause
    @objc func pause(){
        
        guard let player = self.player else{
            return
        }
        
        if player.isPlaying{
            
            self.currentFile?.currentTime = player.currentItem?.currentTime().seconds ?? 0
            self.currentFile?.fileStatus = .pause
            self.delegate?.pauseFile(self.currentFile)
            player.pause()
        }
        self.removePeriodicTimeObserver()
        self.updateAlbum()
    }
    
    // previouse
    @objc func playBackward(){
        
        let current = self.findCurrentTrack()
        let playIndex = current - 1
        if playIndex <= 0 {
            
            self.play(withIndex: 0 )
            return
        }
        
        self.play(withIndex: playIndex)
    }
    
    // next
    @objc func playNext(){
        
        let current = self.findCurrentTrack()
        let playIndex = current + 1
        
        if playIndex <= 0{
            
            self.play(withIndex: 0)
            return
        }
        
        if playIndex >= self.files.count, self.looptype == .all{
            
            self.play(withIndex: 0)
            return
        }else{
            
            self.removePeriodicTimeObserver()
            self.currentFile?.fileStatus = .ready
            self.currentFile?.currentTime = 0
        }
        
        self.play(withIndex: playIndex)
    }
    
    
    func playWithFile(file: File){
        
        for (key, value) in self.files.enumerated(){
            if value.pk == file.pk{
                self.play(withIndex: key)
                return
            }
        }
        
        self.addFileToList(file: file)
        self.play(withIndex: self.files.count - 1)
    }
    
    func removeFromPlayList(file: File){
        for (key, value) in self.files.enumerated(){
            if value.pk == file.pk{
                self.files.remove(at: key)
            }
        }
    }
    
    // fastforward
    func fastForward(){
        
        guard let _ = self.currentFile, let _ = self.player else{
            
            return
        }
        self.changeCurrentTime(secend: (self.currentTime ?? 0) + 15)
    }
    
    // fastbackward
    func fastBackward(){
        
        guard let _ = self.currentFile, let _ = self.player else{
            
            return
        }
        
        self.changeCurrentTime(secend: (self.currentTime ?? 0) - 5)
    }
    
    // Play Action
    @objc func playAction(){
        
        if let currentFile = self.currentFile{
            
            self.play(currentFile)
        }else{
            
            self.play(withIndex: 0)
        }
    }
    
    func addPeriodicTimeObserver() {
        guard let player = self.player else{
            return
        }
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
        
        self.timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
                                                                queue: .main) {
                                                                    [weak self] time in
                                                                    // update player transport UI
                                                                    self?.currentFile?.currentTime = Double(CMTimeGetSeconds(time))
        }
    }
    
    func removePeriodicTimeObserver() {
        guard let player = self.player else{
            return
        }
        
        if let timeObserverToken = self.timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    // Reach The End Of The Video
    @objc fileprivate func reachTheEndOfTheVideo(_ notification: NSNotification) {
        
        switch self.looptype {
        case .one:
            
            self.player?.pause()
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        case .none, .all:
            
            self.playNext()
        case .shuffle:
            let random = Int(arc4random_uniform((UInt32(self.files.count - 1))))
            self.play(self.files[random])
        }
        
        
    }
    
    // Fileprivat Stop
    fileprivate func stop() {
        self.removePeriodicTimeObserver()
        player?.pause()
        player?.seek(to: CMTime.zero)
        self.currentFile?.fileStatus = .ready
        self.currentFile = nil
    }
    
    // Play with File
    fileprivate func play(_ file: File){
        guard let fileURL = file.fileURL else{
            print("file doesnt exist")
            return 
        }
        if(file.pk == self.currentFile?.pk && file.fileStatus == .playing){
            return
        }
        
        if file.fileStatus == .pause{
            
            self.player?.play()
        }else{
        
            self.playerLayer?.removeFromSuperlayer()
            self.stop()
            
            self.player = AVPlayer(url: fileURL)
            self.playerLayer = AVPlayerLayer(player: player)
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
            self.player?.play()
        }
        
        self.currentFile = file
        file.fileStatus = .playing
        self.delegate?.playFile(file)
        self.addPeriodicTimeObserver()
        self.updatePlayerView()
        self.updateAlbum()
    }
    
    // Play file With Index
    fileprivate func play(withIndex: Int){
        
        guard self.files.count > 0, withIndex < self.files.count, withIndex > -1 else{
            
            return
        }
        
        let tf = self.files[withIndex]
        self.play(tf)
    }
    
    // find current
    fileprivate func findCurrentTrack() -> Int{
        
        guard self.files.count > 0 else{
            
            return -1
        }
        
        for (index, currentFile) in self.files.enumerated(){
            
            if currentFile.pk == self.currentFile?.pk{
                
                if (self.files.count - 1) >= index{
                    
                    return index
                }
            }
        }
        
        return -1
    }
    
    // Update UI
    fileprivate func updateUI(){
    }
    
    // play back
    @objc func changedThumbSliderOnLockScreen(_ sender: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus{
        
        guard let track = self.currentFile else{
            
            return MPRemoteCommandHandlerStatus.noSuchContent
        }
        
        if track.fileStatus == FileStatus.pause{
            
            self.player?.play()
            self.changeCurrentTime(secend: sender.positionTime, timeScale: 1000000)
            self.player?.pause()
        }else{
            
            self.changeCurrentTime(secend: sender.positionTime, timeScale: 1000000)
        }
        self.updateAlbum()
        return MPRemoteCommandHandlerStatus.success
    }
    
    fileprivate func updateAlbum(){
        
        guard let track = self.currentFile else{
            
            return
        }
        
        func album(title: String){
            // album detail
            self.getImage(complationHandler: { (image) in
                let albumArt = MPMediaItemArtwork(boundsSize: CGSize(width: 150, height: 150)) { (cgSize) -> UIImage in
                    let image: UIImage = image ?? UIImage()
                    
                    return image
                }
                
                let albumDict = [
                    MPMediaItemPropertyTitle: title,
                    MPMediaItemPropertyArtwork: albumArt,
                    MPMediaItemPropertyPlaybackDuration: self.player?.currentItem?.asset.duration.seconds ?? 0,
                    MPNowPlayingInfoPropertyElapsedPlaybackTime: "0",
                    MPMediaItemPropertyArtist: Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String,
                    ] as [String : Any]
                
                self.playingInfo.nowPlayingInfo = albumDict
                self.playingInfo.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(CMTime(value: CMTimeValue(Int(self.currentTime ?? 0)), timescale: CMTimeScale(1)))
                
            })
            
            
        }
        
        let title = track.title
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            album(title: title)
        }
        
    }
    
    func updatePlayerView(){
        PlayerView.view.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        self.playerLayer?.frame = PlayerView.view.bounds
        self.playerLayer?.videoGravity = AVLayerVideoGravity.resize
        
        if self.player?.currentItem?.asset.tracks(withMediaType: AVMediaType.video).count != 0{
            if let playerLayer = self.playerLayer {
                
                PlayerView.view.layer.insertSublayer(playerLayer, at:0)
            }
        }else{
            self.getImage { (image) in
                self.coverImageView.image = image
            }
            self.coverImageView.frame = PlayerView.view.bounds
            PlayerView.view.addSubview(self.coverImageView)
            PlayerView.view.bringSubviewToFront(self.coverImageView)
        }
        
    }
    
    func setImagePlaceHolder(imagePath: String){
        self.imagePlaceHolderPath = URL(string: imagePath)
    }
    
    fileprivate func getImage(complationHandler: @escaping(_ image: UIImage?)->()) {
        // load local image
        if self.currentFile?.image?.isFileURL ?? false{
            if let imageURL = self.currentFile?.image {
                do {
                    let imageData = try Data(contentsOf: imageURL)
                    if let image = UIImage(data: imageData){
                        complationHandler(image)
                    }
                }catch {
                    print("Not able to load image")
                }
            }
        }
        
        let imagePath: String = self.currentFile?.image?.absoluteString ??  ""
        if let img: UIImage = SDImageCache.shared.imageFromDiskCache(forKey: imagePath) {
            
            complationHandler(img)
            return
        }else if let img: UIImage = SDImageCache.shared.imageFromMemoryCache(forKey: imagePath) {
            
            complationHandler(img)
            return
        }
        if let imgPath = self.imagePlaceHolderPath?.absoluteString{
            let image = UIImage(imageLiteralResourceName: imgPath)
            complationHandler(image)
        }
        SDWebImageManager.init().loadImage(with: self.currentFile?.image, options: .continueInBackground, context: nil, progress: nil) { (img, data, error, cacheType, isSuccess, url) in
            if isSuccess && img != nil{
                complationHandler(img)
                self.updateAlbum()
            }
        }
        
    }
}

extension AVPlayer {
    
    var isPlaying: Bool {
        
        return rate != 0 && error == nil
    }
}
