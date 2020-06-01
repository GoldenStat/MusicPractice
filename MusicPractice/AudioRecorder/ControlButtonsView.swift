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
    var scale: ScaleStruct?
    
    var isPracticing: Bool { stopWatch.isRunning }
    var practiceHasStarted: Bool { stopWatch.hasStarted }
    
    
    /// states: (stopwatch, recorder, store) (0: off, 1: on)
    /// (0,0,0) -> (1,0,0)
    /// (1,0,0) -> (0,0,0)
    /// (1,0,0) -> (1,0,1) -> (0,0,0)
    ///        (1,0,1) -> (1,0,0)
    ///               (1,0,0) -> (1,1,0)
    /// start/stop watch | store + stop recordingRec | Rec/Pause
    var startPauseState: PracticeState { isPracticing ? .Pause : .Start }
    
    /// the recording State
    var recordingButtonState: PracticeState { recorder.isRecordReady ? .REC : .Pause }
    
    /// recording is enabled only when the timer is running
    var isRecordingEnabled: Bool { practiceHasStarted && isPracticing }
    var storeButtonState: PracticeState { isStoreEnabled ? .Store : .Stop }
    
    /// we can only store a lap while we are practicing and not recording
    /// store a recording state
    var isStoreEnabled: Bool {
        // practiceHasStarted &&
        recorder.state == .stopped &&
        recorder.audioURL == nil &&
        !isPracticing }

    var statusText : String {
        if let fileName = recorder.audioURL?.lastPathComponent {
            return "Recording <\(fileName)>"
        } else {
            return "Press Button to start recording"
        }
    }
    
    @State var fileNames: [String] = []
    var recordings: [String] { recorder.recordings.map {$0.fileName} }
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Text("Files recorded")
                        .font(.title)
                    ForEach(fileNames, id: \.self) { name in
                        Text(name)
                    }
                }
                Spacer()
                VStack {
                    Text(recorder.recordingsDirectory.lastPathComponent)
                        .font(.title)
                    ForEach(recordings, id: \.self) { name in
                        Text(name)
                    }
                }
                Spacer()
            }
            Text(statusText)
            HStack {
                
                /// timerButton: controls this sessions time start/pause
                Button(startPauseState.rawValue) {
                    self.pauseResumeStopWatch()
                }
                .buttonStyle(PracticeButtonStyle(state: startPauseState))
                
                Button(storeButtonState.rawValue) {
                    self.storeRecording()
                }
                .buttonStyle(PracticeButtonStyle(state: storeButtonState))
                .disabled(!isStoreEnabled)
                
                Button(recordingButtonState.rawValue) {
                    self.toggleRecording()
                }
                .buttonStyle(PracticeButtonStyle(state: recordingButtonState, isActive: isRecordingEnabled))
                .disabled(!isRecordingEnabled)
            }
        }
    }
    
    func pauseResumeStopWatch() {
        stopWatch.toggleStopStart()
        if stopWatch.isPaused {
            storeRecording()
            fileNames.append(recorder.audioURL?.lastPathComponent ?? "<No audioURL defined>")
        }
    }

    func storeRecording() {
        /// assigns the recording to the current scale
        /// stores the practicing time along with the session
        /// [resets the stopwatch]
        stopWatch.addLap()

        if let _ = recorder.audioURL {
            if recorder.state == .stopped {
                recorder.moveRecording(to: scale)
            }
            recorder.fetchRecordings()
        }
    }
    
    func toggleRecording() {
        recorder.toggleRecording(soft: true)
        if recorder.didFinishRecording {
            recorder.moveRecording(to: self.scale)
            fileNames.append(recorder.audioURL?.lastPathComponent ?? "<No audioURL defined>")
        }
    }
    
}

struct ControlButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlButtonsView(recorder: AudioRecorder(), stopWatch: StopWatch())
    }
}
