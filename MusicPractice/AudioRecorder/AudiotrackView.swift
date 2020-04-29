//
//  AudiotrackView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 26.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct AudiotrackView: View {
    @ObservedObject var recorder: AudioRecorder
                
    var body: some View {
        VStack {
            RecordingList(recorder: recorder)
            
            AudioTrackVisualizerView(recorder: recorder)
                .frame(height: 300)
            
            ToggleButton(recorder: recorder)
        }
    }
    
}

struct ToggleButton: View {

    @ObservedObject var recorder: AudioRecorder
    
    var isRunning : Bool { recorder.isRecording }
    func toggle() {
        recorder.toggleRecording()
    }
    
    enum ButtonState : String {
        case start, stop
    }

    var colors : [ButtonState : Color] = [
        .start: .green,
        .stop: .red,
    ]
    
    var buttonState: ButtonState { isRunning ? .stop : .start }
    var buttonStateColor: Color { colors[buttonState]! }

    var body: some View {
        Button(buttonState.rawValue.capitalized) {
            self.toggle()
        }
        .buttonStyle(TimerButtonStyle(color: buttonStateColor))
    }
}

struct AudiotrackView_Previews: PreviewProvider {
    static var previews: some View {
        AudiotrackView(recorder: AudioRecorder())
    }
}
