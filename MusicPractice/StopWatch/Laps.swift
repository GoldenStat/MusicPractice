//
//  Laps.swift
//  MusicPractice
//
//  Created by Alexander Völz on 03.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

struct Lap: Hashable {
    let id = UUID()
    
    let date: Date
    var dateString : String { date.toString(dateFormat: "y-M-d") }

    let from: TimeInterval
    var start: String { from.longString }

    let to: TimeInterval
    var end: String { to.longString }

    var elapsed: TimeInterval { to - from }
    var duration: String { elapsed.string }

    
    static let sampleLaps : [ Lap ] = [
        Lap(date: Date(timeIntervalSinceNow: -84600), from: 0, to: 72342),
        Lap(date: Date(timeIntervalSinceNow: -36000), from: 0, to: 36054*60),
        Lap(date: Date(), from: 0, to: 6000),
        Lap(date: Date(timeIntervalSinceNow: 84900), from: 0, to: 115400)
    ]
}
