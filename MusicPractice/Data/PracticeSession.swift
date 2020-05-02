//
//  PracticeSession.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

struct PracticeSession : Hashable {
    
    var recordings : [ String ] = []
    var practiceLaps : [ Lap ] = []
}

// scale: C7
// notes: [ .c, .e, .g, .h ]
// recordings: [ title: C7-datestr ]
// practiceSessions: [ (date, start, end) ]
