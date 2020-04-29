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
    var isRunning: Bool { stopWatch.isRunning }
    var time: String { stopWatch.counter.string }
    
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
        VStack {
            LapsListView(laps: stopWatch.laps)
            
            VStack {
                Text(time)
                    .font(.title)
                
                HStack {
                    Button(stopStartState.rawValue.capitalized) { // start / stop button
                        self.stopWatch.toggleStopStart()
                    }
                    .buttonStyle(ScaleButtonStyle(color: colors[stopStartState]!))
                    
                    Button(pauseResetState.rawValue.capitalized) { // start / stop button
                        self.stopWatch.toggleLapReset()
                    }
                    .buttonStyle(ScaleButtonStyle(color: colors[pauseResetState]!))
                }
            }
            .padding()
        }
    }
    
}


struct ScaleButtonStyle: ButtonStyle {
    
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
            .frame(maxWidth: 75, maxHeight: 75)
    }
}


struct LapsListView : View {
    var laps: [Lap]
    
    var numberOfLaps: Int { laps.count }
    var areLapsRecorded: Bool { numberOfLaps > 0 }
    
    
    let header = [ "started", "ended", "elapsed" ]
    var body: some View {
        VStack {
            if numberOfLaps > 0 {
                TitleView(row: header)
                    .font(.headline)
            }
            Section {
                ForEach(self.laps, id: \.self.start) { lap in
                    TitleView(row: [ lap.from.string, lap.to.string, lap.elapsed.string])
                }
            }
        }
        .padding()
    }
}

struct TitleView: View {
    let row: [String]
    var titleCount : Int { row.count }
    
    var body: some View {
        HStack {
            ForEach ( 0 ..< titleCount ) { index in
                if index > 0 {
                    Spacer()
                }
                Text(self.row[index])
            }
            
        }
        
    }
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopWatchView()
    }
}
