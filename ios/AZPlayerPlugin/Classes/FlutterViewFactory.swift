//
//  FlutterViewFactory.swift
//  aparnik_plugin
//
//  Created by Ali Zahedi on 9/24/19.
//

import Foundation
import Flutter

public class FlutterPlayerViewFactory: NSObject, FlutterPlatformViewFactory{
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        guard let argsDict = args as? Dictionary<String, Any>, let sw = argsDict["width"] as? String, let sh = argsDict["height"] as? String, let width = Double(sw), let height = Double(sh) else{
            let rectFrame = CGRect(x: 0, y: 0, width: 350, height: 350)
            return PlayerView(rectFrame, viewId: viewId, args: args)
        }
        
        let rectFrame = CGRect(x: 0, y: 0, width: width, height: height)
        return PlayerView(rectFrame, viewId: viewId, args: args)
    }
    
    
}
