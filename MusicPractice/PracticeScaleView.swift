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


struct PracticeScaleView: View {
    var session : ScalePractice
    
    @ObservedObject var stopWatch = StopWatch()
    var isRunning: Bool { stopWatch.isRunning }
    var elapsed: TimeInterval { stopWatch.counter }
    var time: String { String(elapsed) }
    
    enum ClockState : String {
        case pause, start, lap, reset
    }
    var colors : [ClockState:Color] = [
        .pause: .red,
        .start: .green,
        .lap: .yellow,
        .reset: .orange,
    ]
    
    var pauseResetState: ClockState { isRunning ? .lap : .reset }
    var stopStartState: ClockState { isRunning ? .pause : .start }
    
    var body: some View {
        ZStack {
            
            Color.flatWhite
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(time)
                    .font(.title)
                
                Button(stopStartState.rawValue) { // start / stop button
                    self.stopStart()
                }
                .buttonStyle(TimerButtonStyle(color: colors[stopStartState]!))

                Button(pauseResetState.rawValue) { // start / stop button
                    self.lapReset()
                }
                .buttonStyle(TimerButtonStyle(color: colors[pauseResetState]!))

                LapsList(laps: stopWatch.laps)
            }
        }
        .statusBar(hidden: true)
    }
    
    func lapReset() {
        if stopWatch.isRunning {
            stopWatch.lap()
        } else {
            stopWatch.reset()
        }
    }
    
    func stopStart() {
        if stopWatch.isRunning {
            stopWatch.pause()
        } else {
            if stopWatch.hasStarted {
                stopWatch.resume()
            } else {
                stopWatch.start()
            }
        }
    }
}


struct TimerButtonStyle: ButtonStyle {

    var color: Color
    
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
            .frame(width: 75, height: 75)
    }
}


struct LapsList : View {
    var laps: [Lap]
    
    var body: some View {
        List {
            ForEach(self.laps, id: \.self.start) { lap in
                HStack {
                Text("started: \(lap.start)")
                Text("ended: \(lap.end)")
                Text("elapsed: \(lap.elapsed)")
                }
            }
        }
    }
}
struct PracticeScaleView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeScaleView(session: ScalePractice.sample)
    }
}
