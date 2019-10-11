//
//  File.swift
//  aparnik_plugin
//
//  Created by Ali Zahedi on 9/24/19.
//  Copyright © 2019 Ali Zahedi. All rights reserved.
//

import Foundation
import UIKit

class File{//: Decodable{
    var pk: Int
    var title: String
    var currentTime: Double
    var fileURL: URL?
    var image: URL?
    var fileStatus: FileStatus = .ready
    
    init(pk: Int, title: String, fileURL: URL?, currentTime: Double, fileStatus: FileStatus, image: URL?) {
        self.pk = pk
        self.title = title
        self.fileURL = fileURL
        self.image = image
        self.currentTime = currentTime
        self.fileStatus = fileStatus
    }
    
//    required init(from decoder: Decoder) throws {
    
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        // title
//        if let title = try? container.decode(String.self, forKey: .title){
//
//        }
//
//    }
}
