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

class StopWatch : ObservableObject {

    @Published var counter : TimeInterval
    @Published var hasStarted = false
    @Published var isPaused = false
    @Published var isStopped = true { didSet { if isStopped { isPaused = false } } }
    @Published var laps = [Lap]()

    var elapsed: String { counter.longString }
    
    init() {
        counter = 0.0
    }
    
    var totalLap : Lap {
        Lap(date: Date(),
            from: laps.first?.from ?? 0,
            to: laps.last?.to ?? 0)
    }

    public var isRunning : Bool { !(isPaused || isStopped) }

    private let queue = DispatchQueue(label: "stopwatch.timer")
    private var sourceTimer: DispatchSourceTimer?
    private var started : TimeInterval = 0.0

    
    func addLap() {
        let newLap = Lap(date: Date(), from: started, to: counter)
        laps.append(newLap)
        started = counter
    }
    
    func toggleLapReset() {
        if isRunning {
            addLap()
        } else {
            reset()
        }
    }
    
    func toggleStopStart() {
        if isRunning {
            pause()
        } else {
            if hasStarted {
                resume()
            } else {
                start()
            }
        }
    }

    func reset() {
        started = 0.0
        counter = 0.0
        laps = []
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
                 queue: self.queue)
         }
         
         // give our timer an event to execute
         sourceTimer?.setEventHandler {
             self.counter += 100
         }
         
         // program the timer
         sourceTimer?.schedule(deadline: .now(),
                               repeating: 1.0)

         // start it
         sourceTimer?.resume()

     }
    
    func stop() {
        isStopped = true
        hasStarted = false
    }
    
}
