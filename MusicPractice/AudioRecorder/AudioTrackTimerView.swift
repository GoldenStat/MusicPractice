//
//  AudioTrackTimerView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 29.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct AudioTrackTimerView: View {
    /// pushing 'Store' adds practicelap to the session (stopWatch)
    /// pushing 'Record' adds recording to the session (recorder)
    
    @ObservedObject var recorder : AudioRecorder
    @ObservedObject var stopWatch = StopWatch()
    
    var practiceTime: String { stopWatch.counter.string }

    @State var scale: Scale? = nil
    let testScales : [ Scale? ] = [ nil, .C7, .E7 ]
    
    @State var currentIndex = 0
    func assignNewScale() {
        currentIndex += 1
        scale = testScales[currentIndex%testScales.count]
        recorder.fetchRecordings()
    }
    
    var body: some View {
        VStack {
            Text("Scale: \(scale?.dominant.rawValue ?? "<NA>")")
                .font(.title)
            Button("Change scale") {
                self.assignNewScale()
            }
            
            Divider()
            
            RecordingList(recorder: recorder, scale: scale)

            Group {
                
                AudioTrackVisualizerView(recorder: recorder)
                    .frame(maxHeight: 200)
                
                Divider()
                
                LapsListView(laps: [stopWatch.totalLap])
                    .frame(maxHeight: 200)
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack {
                
                VStack {
                    
                    Divider()
                    
                    ControlButtons(recorder: recorder, stopWatch: stopWatch, scale: scale)
                    
                    Text(practiceTime)
                        .font(.title)
                }
                .frame(minHeight: 140)
            }
        }
    }
    
}
        
struct AudioTrackTimerView_Previews: PreviewProvider {
    static let recorder = AudioRecorder()
    static let stopWatch = StopWatch()
    static let scale : Scale? = .C7
    static var previews: some View {
        VStack {
//            AudioTrackTimerView(recorder: recorder)
            RecordingList(recorder: recorder, scale: nil)
            Divider()
            RecordingList(recorder: recorder, scale: .C7)
            Divider()
            ControlButtons(recorder: recorder,
                           stopWatch: stopWatch,
                           scale: nil)
        }
    }
}

struct ControlButtons: View {
    /// - Interface
    /// - we want to start/pause a timer for while we practice
    /// - while we practice we can start recording a track. If we don't like it, we repeat it
    /// - recording counts as practicing
    /// - start practice -> record track -> [listen to track (pause timer?)] -> store track
    
    @ObservedObject var recorder: AudioRecorder
    @ObservedObject var stopWatch: StopWatch
    var scale: Scale?
    
    var isPracticing: Bool { stopWatch.isRunning }
    var practiceHasStarted: Bool { stopWatch.hasStarted }
    /// the states for the buttons
    var startPauseState: PracticeState { isPracticing ? .Pause : .Start }
    
    var recordingButtonState: PracticeState { !recorder.isRecording ? .REC : .Pause }
    
    /// recording is enabled only when the timer is running
    var isRecordingEnabled: Bool { practiceHasStarted && isPracticing }

    /// we can only store a lap while we are practicing and not recording
    var isStoreEnabled: Bool { practiceHasStarted &&
        !recorder.isRecording &&
        !isPracticing }

    var body: some View {
        HStack {
            
            /// timerButton: controls this sessions time start/pause
            Button(startPauseState.rawValue) {
                self.pauseResumeStopWatch()
            }
            .buttonStyle(PracticeButtonStyle(state: startPauseState))
            
            Button(PracticeState.Store.rawValue) {
                self.storeRecording()
            }
            .buttonStyle(PracticeButtonStyle(state: .Store, isActive: isStoreEnabled))
            .disabled(!isStoreEnabled)
            
            Button(recordingButtonState.rawValue) {
                self.toggleRecording()
            }
            .buttonStyle(PracticeButtonStyle(state: recordingButtonState, isActive: isRecordingEnabled))
            .disabled(!isRecordingEnabled)
        }
    }
    
    func pauseResumeStopWatch() {
        stopWatch.toggleStopStart()
        if stopWatch.isPaused {
            storeRecording()
        }
    }

    func storeRecording() {
        /// assigns the recording to the current scale
        /// stores the practicing time along with the session
        /// [resets the stopwatch]
        stopWatch.addLap()

        if let _ = recorder.audioURL {
            recorder.addRecording(to: scale)
            recorder.fetchRecordings()
        }
//        stopWatch.hasStarted = false
//        stopWatch.reset()
    }
    
    func toggleRecording() {
        recorder.toggleRecording()
        if !recorder.isRecording {
            recorder.addRecording(to: self.scale)
        }
    }
    
}
