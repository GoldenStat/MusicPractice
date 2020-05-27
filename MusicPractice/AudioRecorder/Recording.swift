//
//  RecordingDataMode.swift
//  MusicPractice
//
//  Created by Alexander Völz on 27.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation


struct Recording: Hashable {
    typealias id = URL
    let fileURL: URL
    let created: Date
    
    var fileName: String { fileURL.lastPathComponent }
    
    var components : [ String ] {
        let nameWithoutExtension = fileName.split(separator: ".")[0]
        let parts = nameWithoutExtension.split(separator: ("_"))
        return parts.map { String($0) }
    }
    
    var scaleName: String { components[0] }
    var day: String { components[1] }
    var time: String { components[3] }
    
}
