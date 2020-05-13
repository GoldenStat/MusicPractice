//
//  ControlButtonsView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 13.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ControlButtonsView: View {
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

struct ControlButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlButtonsView(recorder: AudioRecorder(), stopWatch: StopWatch())
    }
}
