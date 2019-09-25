import Flutter
import UIKit

public class SwiftAzPlayerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "az_player_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftAzPlayerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let viewFactory = FlutterPlayerViewFactory()
    registrar.register(viewFactory, withId: "PlayerView")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getPlatformVersion") {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        var files: [File] = []
        
        files.append(File(pk: 2, title: "0 file", fileURL: URL(string: "http://dl11.f2m.co/trailer/Crawl.2019.360p.Trailer.Film2Movie_WS.mp4"), currentTime: 0, fileState: .ready, image: nil))
        
        files.append(File(pk: 0, title: "0 file", fileURL: URL(string: "http://dls.tabanmusic.com/music/1398/07/01/Mehrad-Jam-Khialet-Rahat.mp3"), currentTime: 0, fileState: .ready, image: nil))
        
        files.append(File(pk: 1, title: "0.1 file", fileURL:URL(string: "http://dls.tabanmusic.com/music/1398/06/26/Shahab-Mozaffari-Setayesh.mp3"), currentTime: 0, fileState: .ready, image: nil))
        
        for n in 1...5 {
            var url: URL = documentsPath
            url.appendPathComponent("\(n).mp3")
            let file: File = File(pk: n, title: "\(n) file", fileURL: url, currentTime: 0, fileState: .ready, image: nil)
            files.append(file);
        }
        
        PlayerService.shared.configure(files: files)
        PlayerService.shared.playAction()
        //        PlayerService.shared.playNext()
        
        result("iOS casdf" + UIDevice.current.systemVersion)
    }else{
        result("iOSadsf " + UIDevice.current.systemVersion)
    }
  }
}
