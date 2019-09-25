//
//  FileState.swift
//  aparnik_plugin
//
//  Created by Ali Zahedi on 9/24/19.
//  Copyright © 2019 Ali Zahedi. All rights reserved.
//

import Foundation

enum FileStatus: Int, CaseIterable{
    
    case undefined = 0
    case playing = 1
    case pause = 2
    case stop = 3
    case ready = 4
}
