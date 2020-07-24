//
//  StopWatchModel.swift
//  newApp
//
//  Created by Alexander Völz on 20.07.20.
//

import SwiftUI
import Combine

/// a new stopwatch model
class Clock {
    
    private var cancellableTimer: AnyCancellable?
    var timeInterval: TimeInterval
    
    @Published var counter = 0

    required init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    func start() {
        cancellableTimer = Timer.publish(every: timeInterval, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { _ in
                self.counter += 1
            })
    }
    
    func stop() {
        counter = 0
        cancellableTimer?.cancel()
    }
}

class StopWatchViewModel: ObservableObject {
    
    @Published private(set) var timeBuffer: TimeInterval = 0
    @Published private(set) var laps: [TimeInterval] = []

    // time variables
    public var totalTime: TimeInterval { laps.reduce(0) {$0 + $1} }
    public var timeElapsed: TimeInterval { timeStore + timeBuffer }

    // state variables
    public var didStart: Bool { laps.count > 0 || timeBuffer > 0 }
    public var isRunning: Bool { state == .running }
    public var isPaused: Bool { state == .paused }

    // private variables
    private var timeStore: TimeInterval = 0 // remeber elapsed Time when pausing

    private var cancellable: AnyCancellable!
    private var clock = Clock(timeInterval: 0.1)


    init() {
        cancellable = clock.$counter
            .map { Double($0) }
            .assign(to: \StopWatchViewModel.timeBuffer, on: self)
    }
    
    deinit {
        clock.stop()
        cancellable.cancel()
    }
    
    enum State {
        case running, stopped, paused
    }
    
    private(set) var state: State = .stopped
    
    // MARK: functions to control the StopWatch model
    func start() {
        // start or continue
        if timeStore > 0 {
            clock.counter = Int(timeStore)
            timeStore = 0
        }
        state = .running
        clock.start()
    }
        
    func stop() {
        // reset all counters
        state = .stopped
        laps = []
        timeBuffer = 0
        timeStore = 0
        clock.stop()
    }
    
    func lap() {
        // only add a lap once if time elapsed
        if timeElapsed > 0 {
            if isRunning {
                laps.append(timeBuffer)
                clock.stop()
                clock.start()
            }
        }
    }
        
    func pause() {
        // don't change counter, just stop the timer
        state = .paused
        timeStore = timeBuffer
        clock.stop()
    }
    
}
