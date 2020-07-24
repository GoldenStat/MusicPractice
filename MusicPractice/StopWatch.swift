//
//  Clock.swift
//  MusicPractice
//
//  Created by Alexander Völz on 17.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

// MARK: - buttons
struct StartStopButton: View {
    @EnvironmentObject var stopWatch : StopWatchViewModel

    var text : String { stopWatch.isRunning ? "Stop" : stopWatch.laps.count > 0 ? "Resume" : "Start" }
    var color: Color { stopWatch.isRunning ? .red : .green }
    
    var body: some View {
        Button(text) {
            stopWatch.isRunning ? stopWatch.pause() :
                stopWatch.start()
        }
        .stopWatchStyle(color: color)
    }
}

struct LapResetButton: View {
    @EnvironmentObject var stopWatch : StopWatchViewModel
    
    var text : String { stopWatch.isRunning ? "Lap" : "Reset" }
    var color: Color = .gray
    
    var body: some View {
        Button(text) {
            stopWatch.isRunning ? stopWatch.lap() :
                stopWatch.stop()
        }
        .stopWatchStyle(color: color)
    }
}

// MARK: - example View
struct StopWatchControlCenter: View {

    @ObservedObject var stopWatch = StopWatchViewModel()

    var body: some View {
        VStack {
            
            List {
                ForEach(0 ..< stopWatch.laps.count, id: \.self) { lapNumber in
                    HStack {
                        Text("Lap \(lapNumber):")
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(format: "%.2f", stopWatch.laps[lapNumber]))
                    }
                }
            }
            
            Divider()
            
            Text(String(format: "total: %.2f", stopWatch.totalTime))
            
            Spacer()
            
            Text(String(format: "%.2f", stopWatch.timeElapsed))
                .font(.largeTitle)
            
            HStack {
                LapResetButton()
                StartStopButton()
            }
        }
        .padding()
        .background(Color.noon)
        .environmentObject(stopWatch)
    }
}

struct Clock_Previews: PreviewProvider {
    
    static var previews: some View {
        StopWatchControlCenter()
    }
}
