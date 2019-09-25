//
//  FileState.swift
//  aparnik_plugin
//
//  Created by Ali Zahedi on 9/24/19.
//  Copyright © 2019 Ali Zahedi. All rights reserved.
//

import Foundation

enum FileState: String, CaseIterable{
    
    case readyDownload
    case downloading
    case pauseDownload
    case queue
    case puase
    case play
    case ready
}
