//
//  AudioTrackTimerView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 29.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct AudioTrackTimerView: View {
    @ObservedObject var recorder = AudioRecorder()
    @ObservedObject var stopWatch = StopWatch()
    
    var isRunning: Bool { stopWatch.isRunning }
    var time: String { stopWatch.counter.string }
    
    var title: String = "C7"
    
    @State var practiceTime: TimeInterval = 0
            
    /// the states for the buttons
    var pauseResetState: PracticeState { isRunning ? .Lap : .Reset }
    var stopStartState: PracticeState { isRunning ? .Pause : .Start }
    var buttonState: PracticeState { isRunning ? .REC : .Pause }
    
    var body: some View {
        VStack {
            
            Text("Recordings")
                .font(.headline)
            
            Group {
                RecordingList(recorder: recorder)
                    .frame(maxHeight: 100)
                
                Divider()
                
                AudioTrackVisualizerView(recorder: recorder)
                    .frame(maxHeight: 200)
                
                Divider()
                
                LapsListView(laps: stopWatch.laps)
                    .frame(maxHeight: 200)
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack {
                
                VStack {
                    Divider()
                    
                    HStack {
                        Button(stopStartState.rawValue) { // start / stop button
                            self.stopWatch.toggleStopStart()
                        }
                        .buttonStyle(PracticeButtonStyle(state: stopStartState))
                        
                        Button(PracticeState.Store.rawValue) { // start / stop button
                            self.stopWatch.addLap()
                        }
                        .buttonStyle(PracticeButtonStyle(state: .Store))
                        .disabled(isRunning)
                        
                        Button(buttonState.rawValue) {
                            self.recorder.toggleRecording()
                        }
                        .buttonStyle(PracticeButtonStyle(state: buttonState))
                        .disabled(isRunning)
                    }
                    Text(time)
                        .font(.title)
                }
                .frame(minHeight: 140)
            }
        }
        
    }
}
        
struct AudioTrackTimerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioTrackTimerView()
    }
}
