//
//  File.swift
//  aparnik_plugin
//
//  Created by Ali Zahedi on 9/24/19.
//  Copyright © 2019 Ali Zahedi. All rights reserved.
//

import Foundation
import UIKit

class File{
    var pk: Int
    var title: String
    var currentTime: Double
    var fileURL: URL?
    var image: UIImage?
    var fileState: FileState = .readyDownload
    
    init(pk: Int, title: String, fileURL: URL?, currentTime: Double, fileState: FileState, image: UIImage?) {
        self.pk = pk
        self.title = title
        self.fileURL = fileURL
        self.image = image
        self.currentTime = currentTime
        self.fileState = fileState
    }
}
