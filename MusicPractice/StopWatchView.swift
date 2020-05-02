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

enum PracticeState : String {
    case Pause, Start, Lap, Reset, Store, REC
}


struct StopWatchView: View {
    
    @ObservedObject var stopWatch = StopWatch()
    var isRunning: Bool { stopWatch.isRunning }
    var time: String { stopWatch.elapsed }
    
    var pauseResetState: PracticeState { isRunning ? .Lap : .Reset }
    var stopStartState: PracticeState { isRunning ? .Pause : .Start }
    
    var body: some View {
        VStack {
            LapsListView(laps: stopWatch.laps)
            
            VStack {
                Text(time)
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


struct PracticeButtonStyle: ButtonStyle {

    var state: PracticeState
    var isActive: Bool = true
    func color(forState state: PracticeState) -> Color {
        switch state {
        case .Pause: return .red
        case .Start: return .green
        case .Lap: return .yellow
        case .Reset: return .orange
        case .Store: return .orange
        case .REC: return .red
        }
    }

    var color: Color { color(forState: state) }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Circle()
            .fill(color)
            .overlay(
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .padding(4)
        )
            .overlay(configuration.label
                .foregroundColor(.white)
        )
        .overlay(Circle()
            .fill(isActive ? Color.clear : Color.gray)
            .opacity(0.4)
        )
            .frame(maxWidth: 75, maxHeight: 75)
    }
}


struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopWatchView()
    }
}
