//
//  PlayerView.swift
//  aparnik_plugin
//
//  Created by Ali Zahedi on 9/24/19.
//

import Foundation
import Flutter

public class PlayerView: NSObject, FlutterPlatformView{
    
    static var view: UIView = UIView()
    var frame: CGRect
    var viewId: Int64
    
    init(_ frame: CGRect, viewId: Int64, args: Any?){
        self.frame = frame
        self.viewId = viewId
    }
    
    public func view() -> UIView {
        PlayerView.view.frame = self.frame
        PlayerService.shared.updatePlayerView()
        return PlayerView.view
    }
}
