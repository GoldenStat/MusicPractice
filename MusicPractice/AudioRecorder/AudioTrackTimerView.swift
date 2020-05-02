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
    @ObservedObject var practiceStopWatch = StopWatch()
    @ObservedObject var recordingStopWatch = StopWatch()

    var isPracticing: Bool { practiceStopWatch.isRunning }
    var practiceTime: String { practiceStopWatch.counter.string }
    var practiceHasStarted: Bool { practiceStopWatch.hasStarted }
    
    var title: String = "C7"
                
    /// the states for the buttons
    var pauseResetState: PracticeState { isPracticing ? .Lap : .Reset }
    var stopStartState: PracticeState { isPracticing ? .Pause : .Start }
    var recordingButtonState: PracticeState { !recorder.isRecording ? .REC : .Pause }
    var isRecordingEnabled: Bool { practiceHasStarted && isPracticing }
    
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
                
                LapsListView(laps: practiceStopWatch.laps)
                    .frame(maxHeight: 200)
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack {
                
                VStack {
                    
                    Divider()
                    
                    HStack {
                        Button(stopStartState.rawValue) {
                            self.practiceStopWatch.toggleStopStart()
                        }
                        .buttonStyle(PracticeButtonStyle(state: stopStartState))
                        
                        Button(PracticeState.Store.rawValue) {
                            self.practiceStopWatch.addLap()
                        }
                        .buttonStyle(PracticeButtonStyle(state: .Store, isActive: practiceHasStarted))
                        .disabled(!practiceHasStarted)
                        
                        Button(recordingButtonState.rawValue) {
                            self.recorder.toggleRecording()
                        }
                        .buttonStyle(PracticeButtonStyle(state: recordingButtonState, isActive: isRecordingEnabled))
                        .disabled(!isRecordingEnabled)
                    }
                    
                    Text(practiceTime)
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
