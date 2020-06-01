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
struct PracticeInstance : Hashable, Identifiable {
    var id = UUID()
    var date: Date = Date()
    var recordingURL : URL? = nil
    var practiceTime : TimeInterval = 0
    var practiceScale: ScaleStruct
}

func ==(A:PracticeInstance, B:PracticeInstance) -> Bool {
    A.id == B.id
}

/// The Data we need for  one practice session
/// - Parameters:
/// - Parameter date: each instance has a date, but let's save another one, here
/// - Parameter instances: all the instances we practiced today
/// - Parameter practiceTime: how long did we practice
/// - Parameter practiceScales: which scale did we practice
struct PracticeSession: Hashable {
    var date = Date()
    var instances: [PracticeInstance] = []
    var practiceTime: TimeInterval { instances.reduce(0) {$0 + $1.practiceTime} }
    var practiceScales: [ScaleStruct] { instances.map {$0.practiceScale} }
    
    mutating func addInstance(instance: PracticeInstance) {
        instances.append(instance)
    }
}
