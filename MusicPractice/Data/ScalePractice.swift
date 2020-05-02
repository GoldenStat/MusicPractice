//
//  ScalePractice.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation


/// ScalePractice
/// - Parameters:
/// - name: which scale
/// - date: day we practiced
/// - start: time we started the session (in seconds)
/// - end: time we ended the session (in seconds)
/// - duration: time we practiced (in seconds)
/// - track: recording of the scale (cleaned up)
struct ScalePracticeSession {
    var scale: MusicScale
    var date: Date
    var start: TimeInterval = 0
    var end: TimeInterval = 0
    var duration: TimeInterval { end - start }
    
    var track: MusicTrack?
    var trackTitle: String
//    init(scale: MusicScale, date: Date, start: TimeInterval = 0, end: TimeInterval = 0, track: MusicTrack? = nil, trackTitle: String?) {
//        self.scale = scale
//        self.date = date
//        self.start = start
//        self.end = end
//        self.track = track
//    self.title = title
//    }
}

