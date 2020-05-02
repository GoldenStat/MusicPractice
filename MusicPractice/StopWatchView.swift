//
//  PracticeScaleView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Color {
    static let flatWhite = Color(red: 255 / 255, green: 255 / 255, blue: 230 / 255)
}

struct StopWatchView: View {
    
    @ObservedObject var stopWatch = StopWatch()

    
    var pauseResetState: PracticeState { stopWatch.isRunning ? .Lap : .Reset }
    var stopStartState: PracticeState { stopWatch.isRunning ? .Pause : .Start }
    
    var body: some View {
        VStack {
            LapsListView(laps: stopWatch.laps)
            
            VStack {
                Text(stopWatch.elapsed)
                    .font(.title)
                
                HStack {
                    Button(stopStartState.rawValue.capitalized) { // start / stop button
                        self.stopWatch.toggleStopStart()
                    }
                    .buttonStyle(PracticeButtonStyle(state: stopStartState))
                    
                    Button(pauseResetState.rawValue.capitalized) { // start / stop button
                        self.stopWatch.toggleLapReset()
                    }
                    .buttonStyle(PracticeButtonStyle(state: pauseResetState, isActive: stopWatch.hasStarted))
                    .disabled(!stopWatch.hasStarted)
                }
            }
            .padding()
        }
    }
    
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopWatchView()
    }
}
