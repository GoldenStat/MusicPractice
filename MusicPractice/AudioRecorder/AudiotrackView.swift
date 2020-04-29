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
            
            AudioRecorderButton(recorder: recorder)
        }
    }
    
}

struct AudiotrackView_Previews: PreviewProvider {
    static var previews: some View {
        AudiotrackView(recorder: AudioRecorder())
    }
}
