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
    
    var practiceTime: String { stopWatch.counter.longString }

    @Binding var scale: Scale
        
    var body: some View {
        VStack {
                        
            RecordingList(recorder: recorder, scale: scale)

            Group {
                
                AudioTrackVisualizerView(recorder: recorder)
                    .frame(maxHeight: 200)
                
                Divider()
                
            }
            .padding(.horizontal)
                        
            VStack {
                
                VStack {
                    
                    Text(practiceTime)
                        .font(.largeTitle)
                    Divider()
                    ControlButtonsView(recorder: recorder, stopWatch: stopWatch, scale: scale)
                }
                .frame(minHeight: 200)
            }
        }
    }
    
}
        
struct AudioTrackTimerView_Previews: PreviewProvider {
    static let recorder = AudioRecorder()
    static let stopWatch = StopWatch()
    static let scale : Scale = .C7
    static var previews: some View {
        AudioTrackTimerView(recorder: recorder, scale: .constant(scale))
    }
}

