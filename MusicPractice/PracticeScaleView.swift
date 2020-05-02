//
//  PracticeScaleView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 26.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI



struct PracticeScaleView: View {
        
    @State var currentScale: Scale
    
    var body: some View {
        ZStack {
            
            Color.flatWhite
                .edgesIgnoringSafeArea(.all)
            VStack {
                Group {
                    //                    Text("Choose a scale to practice")
                    //                        .font(.title)
                    
                    /// show a picker which scale to select
                    Picker("currentScale", selection: $currentScale.scale) {
                        ForEach(MusicScale.allCases, id: \.self) { scale in
                            Text(scale.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    /// show the notes for the current selection
                    HStack {
                        Text(currentScale.scale.rawValue)
                            .font(.largeTitle)
                        Spacer()
                        HStack {
                            ForEach(currentScale.notes, id: \.self) { note in
                                Text(note.rawValue)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                Group {
                    AudioTrackTimerView(recorder: AudioRecorder())
                }
            }
        }
        .statusBar(hidden: true)
    }
    
    
    func recordLaps() {
        
    }
    
    func load(_ scale: MusicScale) {
        print("loading sessions for: ", scale.rawValue)
    }
}

struct PracticeScaleView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeScaleView(currentScale: Scale.C7)
    }
}
