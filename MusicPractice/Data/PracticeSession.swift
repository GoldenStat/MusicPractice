//
//  PracticeSession.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation


/// The Data we need for  one practice Instance
/// - Parameters:
/// - Parameter date: when did we practice
/// - Parameter recording: the audio file we wish to keep as reference for our progress
/// - Parameter practiceTime: how long did we practice
/// - Parameter practiceScale: which scale did we practice
struct PracticeInstance : Hashable {
    var date: Date = Date()
    var recordingURLs : [ URL ] = []
    var practiceTime : TimeInterval = 0
    var practiceScale: Scale
}

/// The Data we need for  one practice session
/// - Parameters:
/// - Parameter date: each instance has a date, but let's save another one, here
/// - Parameter instances: all the instances we practiced today
/// - Parameter practiceTime: how long did we practice
/// - Parameter practiceScale: which scale did we practice
struct PracticeSession: Hashable {
    var date = Date()
    var instances: [PracticeInstance]
}
