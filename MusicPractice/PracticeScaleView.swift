//
//  PracticeScaleView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 26.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PracticeScaleView: View {
    
    var selectedScale: MusicScale { currentScale.scale }
    var currentNotes: [Notes] { currentScale.notes }
    @State var currentScale: Scale { willSet {
        recordLaps()
        }}
    @State var recordedLaps: [ Scale: [Lap] ] = [:]
    
    func notes(scale: MusicScale) -> [ Notes ] {
        return Scale.notes(scale: scale)
    }
    
    var body: some View {
        ZStack {
            
            Color.flatWhite
                .edgesIgnoringSafeArea(.all)
        VStack {
            Text("Choose a scale to practice")
            
            /// show a picker which scale to select
            Picker("currentScale", selection: $currentScale.scale) {
                ForEach(MusicScale.allCases, id: \.self) { scale in
                    Text(scale.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            /// show the notes for the current selection
                Text(selectedScale.rawValue)
                .font(.largeTitle)
                .frame(height: 80)
            HStack {
                ForEach(self.notes(scale: selectedScale), id: \.self) { note in
                    Text(note.rawValue)
                }
            }

            Spacer()
            
            StopWatchView()
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
        PracticeScaleView(currentScale: Scale.Cis7)
//        PracticeScaleView(selectedScale: .C7)

    }
}
