//
//  PracticeScaleView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 26.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PracticeScaleView: View {
    
//    var selectedScale: MusicScale
    @Binding var currentScale: Scale
    
    var body: some View {
        ZStack {
            
            Color.flatWhite
                .edgesIgnoringSafeArea(.all)
        VStack {
            Text("Choose a scale to practice")
            
            /// show a picker which scale to select
//            Text("current Scale: D7")
            Picker("scale", selection: $currentScale.scale) {
                ForEach(Scale.Practice, id: \.self) { practice in
                    Text(practice.scale.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            /// upon selection, show a summary of progress so far
            /// load History()
            /// upon selection, show a timer button, show time how long this scale is being practiced

            /// show the notes for the current selection
            Text(currentScale.scale.rawValue)
                .font(.largeTitle)
                .frame(height: 80)
            HStack {
                ForEach(currentScale.notes, id: \.self) { note in
                    Text(note.rawValue)
                }
            }

            Spacer()
            
            StopWatchView()
            
            
            }
        }
        .statusBar(hidden: true)
    }
    
    func load(_ scale: MusicScale) {
        print("loading sessions for: ", scale.rawValue)
    }
}

struct PracticeScaleView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeScaleView(currentScale: .constant(Scale.Cis7))
    }
}
