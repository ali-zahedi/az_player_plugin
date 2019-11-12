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
    static var frame: CGRect = CGRect(x: 0, y: 0, width: 260, height: 90)
    var viewId: Int64
    
    init(_ frame: CGRect, viewId: Int64, args: Any?){
        PlayerView.frame = frame
        self.viewId = viewId
    }
    
    public func view() -> UIView {
        PlayerView.view.frame = PlayerView.frame
        PlayerService.shared.updatePlayerView()
        return PlayerView.view
    }
}
