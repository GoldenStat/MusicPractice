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
    let from: TimeInterval
    let to: TimeInterval
    var elapsed: TimeInterval { to - from }

    var start: String { from.longString }
    var end: String { to.longString }
}

/// 
extension TimeInterval {
    var longString: String {
        let centiseconds = Int(self.truncatingRemainder(dividingBy: 100))
        return String(format:"\(string).%02d",centiseconds)
    }
    
    var string: String {
        let seconds = Int(self) / 100
        let minutes = seconds / 60
        let hours = minutes / 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

class StopWatch : ObservableObject {
//    var didChange = PassthroughSubject<Void, Never>()

    static private let queue = DispatchQueue(label: "stopwatch.timer")

    @State private var counter : TimeInterval = 0.0
    var elapsed: String { counter.longString }
    
    @Published var hasStarted = false
    @Published var isPaused = false
    @Published var isStopped = true
        { didSet { if isStopped { isPaused = false } } }
    @Published var laps = [Lap]()

    public var isRunning : Bool { !(isPaused || isStopped) }

    private var sourceTimer: DispatchSourceTimer?
    private var started : TimeInterval = 0.0

    
    func lap() {
        let newLap = Lap(from: started, to: counter)
        laps.append(newLap)
        started = counter
    }
    
    func reset() {
        sourceTimer = nil
        started = 0.0
        counter = 0.0
        hasStarted = false
        isPaused = false
        isStopped = true
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

struct StopWatch_Previews: PreviewProvider {
    static var previews: some View {
        PracticeScaleView(session: ScalePractice.sample)
    }
}
