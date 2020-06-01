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
                
    @Binding var scale: Scale
    
//    var buttonState: PracticeState { recorder.state == .recording ? .Pause : .REC}
//    var buttonStateWait: PracticeState { recorder.state == .stopped ? .Stop : .Start}

    var body: some View {
        VStack {
            RecordingList(recorder: recorder, scale: scale)
            
            AudioTrackVisualizerView(recorder: recorder)
            
//            Button(buttonState.rawValue.uppercased()) {
//                self.recorder.toggleRecording(soft: true)
//            }
//            .buttonStyle(PracticeButtonStyle(state: buttonState))
//            Button(buttonState.rawValue.uppercased()) {
//                self.recorder.toggleRecording(soft: true)
//            }
//            .buttonStyle(PracticeButtonStyle(state: buttonState))
//            Button(buttonStateWait.rawValue.uppercased()) {
//                self.recorder.toggleRecording(soft: false)
//            }
//            .buttonStyle(PracticeButtonStyle(state: buttonState))
        }
    }
    
}

struct AudiotrackView_Previews: PreviewProvider {
    static var previews: some View {
        AudiotrackView(recorder: AudioRecorder()
            , scale: .constant(.C7))
    }
}
