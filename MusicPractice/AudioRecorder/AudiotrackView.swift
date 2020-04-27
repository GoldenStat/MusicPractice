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
    
    enum ButtonState : String {
        case start, stop
    }
    
    var colors : [ButtonState : Color] = [
        .start: .green,
        .stop: .red,
    ]
    
    var startStopButtonState: ButtonState { recorder.isRecording ? .stop : .start }
    
    
    var body: some View {
        VStack {
            RecordingList(recorder: recorder)
            
            Button(startStopButtonState.rawValue.capitalized) {
                self.startStopRecording()
            }
            .buttonStyle(TimerButtonStyle(color: colors[startStopButtonState]!))
        }
    }
    
    func startStopRecording() {
        recorder.isRecording ?
            recorder.stop() :
            recorder.start()
    }
}

struct AudiotrackView_Previews: PreviewProvider {
    static var previews: some View {
        AudiotrackView(recorder: AudioRecorder())
    }
}
