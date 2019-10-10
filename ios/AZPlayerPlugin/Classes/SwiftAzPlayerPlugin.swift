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
    
    if (call.method == "duration") {
        
        result(PlayerService.shared.totalTime)
    }else if(call.method == "currentTime"){
        
        result(PlayerService.shared.currentTime)
    }else if(call.method == "secondsLeft") {
        
        let totalTime: Double = PlayerService.shared.totalTime ?? 0
        let currentTime: Double = PlayerService.shared.currentTime ?? 0
        result( totalTime - currentTime)
    }else if(call.method == "currentFile") {
    
        result(PlayerService.shared.currentFile?.pk)
    }else if(call.method == "isPlaying") {
        
        result(PlayerService.shared.isPlaying)
    }else if(call.method == "play") {
        
        PlayerService.shared.playAction()
        result(true)
    }else if(call.method == "playWithFile") {
        
        let file: File? = self.convertToFile(args: call.arguments)
        if ( file != nil ){
            PlayerService.shared.playWithFile(file: file!)
            result(true)
        }else{
            result(false)
        }
    }else if(call.method == "pause") {
        
        PlayerService.shared.pause()
        result(true)
    }else if(call.method == "stop") {
        
        PlayerService.shared.stop(self)
        result(true)
    }else if(call.method == "addFileToPlayList") {
        
        let file: File? = self.convertToFile(args: call.arguments)
        if ( file != nil ){
            PlayerService.shared.addFileToList(file: file!)
            result(true)
        }else{
            result(false)
        }
    }else if(call.method == "addFilesToPlayList") {
        
        let files: [File] = self.convertToFiles(args: call.arguments ?? nil)
        
        PlayerService.shared.addFilesToList(files: files)
        result(true)
        
    }else if(call.method == "emptyPlayList") {
        
        PlayerService.shared.stop(self)
        PlayerService.shared.configure(files: [])
    }else if(call.method == "removeFromPlayList") {
        
        let file: File? = self.convertToFile(args: call.arguments)
        if ( file != nil ){
            PlayerService.shared.removeFromPlayList(file: file!)
            result(true)
        }else{
            result(false)
        }
    }else if(call.method == "getPlayList") {
        
        // TODO:
    }else if(call.method == "next") {
        
        PlayerService.shared.playNext()
        result(true)
    }else if(call.method == "previous") {
        
        PlayerService.shared.playBackward()
        result(true)
    }else if(call.method == "changeTime") {
        
        let time: Double? = call.arguments as? Double
        if ( time != nil ){
            PlayerService.shared.changeCurrentTime(secend: time!)
            result(true)
        }else{
            result(false)
        }
    }else if(call.method == "fastForward") {

             PlayerService.shared.fastForward()
             result(true)
    }else if(call.method == "fastBackward") {

          PlayerService.shared.fastBackward()
          result(true)
    }else if(call.method == "setImagePlaceHolder") {
         guard let imagePath: String = call.arguments as? String else{
            result(false)
            return
        }
        PlayerService.shared.setImagePlaceHolder(imagePath: imagePath)
        result(true)
     }
  }
    
    func convertToFile(args: Any?) -> File?{
        guard let argsDict = args as? Dictionary<String, Any>
        else{
            return nil
        }
        
        guard         let pk = argsDict["pk"] as? Int,
            let title = argsDict["title"] as? String,
            let currentTime = argsDict["currentTime"] as? Double,
            let fileURL = argsDict["fileURL"] as? String,
            let fileStatus = argsDict["fileStatus"] as? Int
            else{
                return nil
        }
        let imagePath: String? = argsDict["imagePath"] as? String,
        //        TODO: image address
        return File(pk: pk, title: title, fileURL: URL(string: fileURL), currentTime: currentTime, fileStatus: FileStatus(rawValue: fileStatus) ?? .ready, image: UIImage())
    }
    
    func convertToFiles(args: Any?) -> [File]{
        var files: [File] = []
        guard let argsArray = args as? Array<Any>
            else{
                
            return files
        }
        
        for value in argsArray{
            let file = self.convertToFile(args: value)
            if(file != nil){
            files.append(file!)
            }
        }
        return files
    }
}
