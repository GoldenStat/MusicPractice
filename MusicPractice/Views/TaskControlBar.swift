//
//  TaskControlView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 23.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct TaskControlBar : View {
    @ObservedObject var stopWatch = StopWatchViewModel()
    @ObservedObject var recorder = AVRecorderViewModel()
    var taskName: String

    struct ControlBarControls {
        var showRecordings = false // show a list of recordings, as well
        var showLaps = false // show how many laps were stopped
        var showTimer = false // show the current stopped time
        var showTimerSum = false // show the sum
    }

    var recordings: [ ResultRecord ] { recorder.recordings }
    var laps: [ TimeInterval ] { stopWatch.laps }
    
    var controls = ControlBarControls()
        
    var body: some View {
        VStack {
            if controls.showRecordings {
                RecordingsList()
                    .animation(nil)
            }
            
            if controls.showLaps || controls.showTimer {
                LapList()
            }
            
            if controls.showTimer {
                TimeMonitor(showTimerSum: controls.showTimerSum)
            }
            
            HStack {
                RecordingButton(isDisabled: !stopWatch.isRunning)
                StartStopButton()
                LapResetButton()
            }
        }
        .environmentObject(stopWatch)
        .environmentObject(recorder)
        .animation(.default)
    }
}

struct TimeMonitor: View {
    @EnvironmentObject var stopWatch: StopWatchViewModel
    
    var showTimerSum: Bool = false
    
    var body: some View {
        
        VStack {
            
            Spacer()

            Divider()
            
            if showTimerSum {
                Text(String(format: "total: %.2f", stopWatch.totalTime))
            }
                        
            Text(String(format: "%.2f", stopWatch.timeElapsed))
                .font(.largeTitle)
        }
    }
}

struct LapList : View {
    @EnvironmentObject var stopWatch : StopWatchViewModel
    
    var laps: [ TimeInterval ] { stopWatch.laps }
    
    var body: some View {
        List {
            ForEach(0 ..< laps.count, id: \.self) { lapNumber in
                HStack {
                    Text("Lap \(lapNumber):")
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(format: "%.2f", stopWatch.laps[lapNumber]))
                }
            }
        }
    }
}

struct RecordingsList : View {
    @EnvironmentObject var recorder: AVRecorderViewModel
    
    var recordings: [ ResultRecord ] { recorder.recordings }
    
    var body: some View {
        List {
            ForEach(recordings) { recording in
                HStack {
                    Text(recording.fileName)
                    Spacer()
                    PlaybackButton(url: recording.url)
                }
            }
            .onDelete() { offsets in
                recorder.deleteRecordings(urls: offsets.map { recordings[$0].url } )
            }
            .animation(nil)
        }
    }
}

struct ControlButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TaskControlBar(taskName: Scale.C7.description,
                           controls: .init(showRecordings: true,
                                           showLaps: true,
                                           showTimer: true,
                                           showTimerSum: true)
            )
        }
    }
}
