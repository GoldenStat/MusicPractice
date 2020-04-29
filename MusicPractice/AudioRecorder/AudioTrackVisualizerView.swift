//
//  AudioTrackVisualizerView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 27.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct AudioTrackVisualizerView: View {
    
    @ObservedObject var recorder: AudioRecorder

    var body: some View {
        GeometryReader { geometry in
        HStack {
            ForEach(self.recorder.soundSamples, id: \.self) { level in
                SoundBarView(value: self.normalizeSoundLevel(level: level, to: geometry.size))
            }
        }
        }
    }

    private func normalizeSoundLevel(level: Float, to size: CGSize) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (size.height / 25)) // scaled to max at 300 (our height of our bar)
    }

}

struct AudioTrackVisualizerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AudioTrackVisualizerView(recorder: AudioRecorder(numberOfSamples: 20))
        }
    }
}
