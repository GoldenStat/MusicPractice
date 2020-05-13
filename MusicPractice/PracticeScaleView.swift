//
//  PracticeScaleView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 26.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI


extension Color {
    static let flatWhite = Color(red: 255/255, green: 255/255, blue:235/255)
}

struct PracticeScaleView: View {
        
    @State var currentScale: Scale
    let recorder = AudioRecorder()
    
    var body: some View {
        ZStack {
            
            Color.flatWhite
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Group {
                    
                    /// show a picker which scale to select
                    ScalePicker(selection: $currentScale)
                    
                    /// show the notes for the current selection
                    ScaleDetailRow(scale: currentScale)
                }
                
                Spacer()
                
                Group {
                    RecordingList(recorder: recorder, scale: currentScale)
                        .frame(maxHeight: 200)
                    
                    Divider()

                    AudioTrackTimerView(recorder: recorder)
                }
            }
        }
        .padding(.horizontal)
        .statusBar(hidden: true)
    }
    
    
    func recordLaps() {
        
    }
    
    func load(_ scale: Scale) {
        print("loading sessions for: ", scale.name)
    }
}

struct PracticeScaleView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeScaleView(currentScale: Scale.C7)
    }
}

struct ScalePicker: View {
    var selection: Binding<Scale>
    var body: some View {
        Picker("currentScale", selection: selection.dominant) {
            ForEach(Scale.selectableScales, id: \.self) { dominant in
                Text(dominant.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct ScaleDetailRow: View {
    var scale: Scale
    var body: some View {
        HStack {
            Text(scale.dominant.rawValue)
                .font(.largeTitle)
            Spacer()
            HStack {
                ForEach(scale.notes, id: \.self) { note in
                    Text(note.rawValue)
                }
            }
        }
        .padding()
    }
}
