//
//  MusicRecord.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

/// a practice Record stores all information about a task that is practiced
/// - parameters
/// - date: when was the task practiced
/// * duration: how much time did you invest
/// - result: what was the outcome of the practice (optional)
/// - name: what was practiced
struct TaskRecord : Codable, Identifiable {
    var id = UUID()
    var name: String { scale.description }
    var date: Date = Date()
    var duration: TimeInterval = TimeInterval(Int.random(in: minDuration ... maxDuration))
    var result: ResultRecord?
    var scale: ScaleStruct
    
    static let minDuration = 43
    static let maxDuration = 234
    
    static var samples = [
        TaskRecord(scale: ScaleStruct(key: .C, mood: .dominant)),
        TaskRecord(scale: ScaleStruct(key: .D, mood: .dominant)),
        TaskRecord(scale: ScaleStruct(key: .E, mood: .dominant)),
        TaskRecord(scale: ScaleStruct(key: .F, mood: .dominant)),
        TaskRecord(scale: ScaleStruct(key: .G, mood: .dominant)),
    ]
}

/// the outcome of a tasks practiced, i.e. the performance after practicing, e.g. a recording
/// how is the performance after having practiced a task (proof of exitus)
/// - url: where is the result stored (proof of quality)
/// - date: should be the same as the task's date
/// - duration: mesaure the performance in time (speed) it requires to perform the task in a good quality
/// - quality: an Integer to measure how happy I am with the performance (cutting corners / clean recording)
///
/// a result record is assigned to a task when the practice has it's desired outcomt (record after practice)
struct ResultRecord : Codable, Identifiable {
    var id = UUID()
    var fileName: String { url.lastPathComponent }
    var date: Date
    var url: URL
    var duration: TimeInterval // a unit of measuring the achieved
    var quality: Int? // give this a rating
}

/// a practiceSession is an accumulation of practiced tasks
/// overallQuality: an attempt to give an overall value to the session
struct PracticeSessionRecord : Codable {
    var practiceRecords: [TaskRecord] = []
    var date: Date = Date()
    
    var overallQuality: Double {
        let samplesThatHaveRecordings = practiceRecords.compactMap { $0.result?.quality }
//        let samplesIncludingThoseWithNoEvidence = practiceRecords.map { $0.result?.quality ?? 0 }
        let samples = samplesThatHaveRecordings
        let sum = samples.reduce(0) { $0 + $1 }
        return Double(sum / samples.count)
    }
    
    static let sample = PracticeSessionRecord()
}
