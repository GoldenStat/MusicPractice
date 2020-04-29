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
            RecordingList(recorder: recorder)
            
            AudioTrackVisualizerView(recorder: recorder)
            
            VStack {
                LapsListView(laps: stopWatch.laps)
                
                VStack {
                    
                    HStack {
                        Button(stopStartState.rawValue.capitalized) { // start / stop button
                            self.stopWatch.toggleStopStart()
                        }
                        .buttonStyle(ScaleButtonStyle(color: colors[stopStartState]!))
                        
                        Button(pauseResetState.rawValue.capitalized) { // start / stop button
                            self.stopWatch.toggleLapReset()
                        }
                        .buttonStyle(ScaleButtonStyle(color: colors[pauseResetState]!))
                        
                        AudioRecorderButton(recorder: recorder)
                    }
                    Text(time)
                        .font(.title)
                }
            }
        }
        
    }
}

struct AudioRecorderButton: View {

    @ObservedObject var recorder: AudioRecorder
    
    var isRunning : Bool { recorder.isRecording }
    func toggle() {
        recorder.toggleRecording()
    }
    
    enum ButtonState : String {
        case record, pause
    }

    var colors : [ButtonState : Color] = [
        .record: .purple,
        .pause: .gray,
    ]
    
    var buttonState: ButtonState { isRunning ? .pause : .record }
    var buttonStateColor: Color { colors[buttonState]! }

    var body: some View {
        Button(buttonState.rawValue.capitalized) {
            self.toggle()
        }
        .buttonStyle(ScaleButtonStyle(color: buttonStateColor))
    }
}

struct AudioTrackTimerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioTrackTimerView()
    }
}
