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
}
