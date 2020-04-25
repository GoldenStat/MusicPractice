//
//  Timer.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct Lap {
    let start: TimeInterval
    let end: TimeInterval
    var elapsed: TimeInterval { end - start }
}

class StopWatch : ObservableObject {
//    var didChange = PassthroughSubject<Void, Never>()

    static private let queue = DispatchQueue(label: "stopwatch.timer")

    @Published var counter : TimeInterval = 0.0
    @Published var isPaused = false
    @Published var hasStarted = false
    @Published var isStopped = true
        { didSet { if isStopped { isPaused = false } } }
    @Published var laps = [Lap]()

    public var isRunning : Bool { !(isPaused || isStopped) }

    private var sourceTimer: DispatchSourceTimer?
    private var started : TimeInterval = 0.0

    
    func lap() {
        let newLap = Lap(start: started, end: counter)
        laps.append(newLap)
        started = counter
    }
    
    func reset() {
        sourceTimer = nil
        counter = 0.0
        isPaused = false
        isStopped = true
        hasStarted = false
        laps = []
        started = 0.0
    }
    
    func pause() {
        isPaused = true
        sourceTimer?.suspend()
    }
    func resume() {
        isPaused = false
        sourceTimer?.resume()
    }


    func start() {
        /// if we don't have a atimer, create one
        /// then resume operation

        isStopped = false
        hasStarted = true
        
        // create a timer if none exists
        if sourceTimer == nil {
            sourceTimer = DispatchSource.makeTimerSource(
                flags: DispatchSource.TimerFlags.strict,
                queue: Self.queue)
        }
        
        // give our timer an event to execute
        sourceTimer?.setEventHandler {
            self.counter += 1
        }
        
        // program the timer
        sourceTimer?.schedule(deadline: .now(),
                              repeating: 0.01)

        // start it
        sourceTimer?.resume()

    }
                
    func stop() {
        isStopped = true
        hasStarted = false
//        sourceTimer = nil
    }
    
    
}
