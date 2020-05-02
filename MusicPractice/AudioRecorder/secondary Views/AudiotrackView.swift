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
                
    var buttonState: PracticeState { recorder.isRecording ? .Pause : .REC}
    
    var body: some View {
        VStack {
            RecordingList(recorder: recorder)
            
            AudioTrackVisualizerView(recorder: recorder)
            
            Button(buttonState.rawValue.uppercased()) {
                self.recorder.toggleRecording()
            }
            .buttonStyle(PracticeButtonStyle(state: buttonState))
        }
    }
    
}

struct AudiotrackView_Previews: PreviewProvider {
    static var previews: some View {
        AudiotrackView(recorder: AudioRecorder())
    }
}
