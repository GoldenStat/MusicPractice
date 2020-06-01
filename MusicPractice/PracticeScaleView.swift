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
        
    @State var scale: ScaleStruct
        
    let recorder = AudioRecorder()
    
    var body: some View {
        ZStack {
            
            Color.flatWhite
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Emphasize {
                    BandoneonHSlide(playingDirection: .open,
                                    hightlightedNotes: scale.notes)
                }
                /// show a picker which scale to select
                ScalePicker(selection: $scale)
                ModePicker(selection: $scale)
                
                /// show the notes for the current selection
                ScaleDetailRow(scale: scale)
                
                
                Spacer()
                
                Divider()

                RecordingList(recorder: recorder, scale: scale)

                AudioTrackTimerView(recorder: recorder, scale: $scale)
            }
        }
        .padding(.horizontal)
        .statusBar(hidden: true)
    }
    
    
    func recordLaps() {
        
    }
    
    func load(_ scale: ScaleStruct) {
        print("loading sessions for: ", scale.string)
    }
}

struct PracticeScaleView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeScaleView(scale: Scale.C7)
    }
}

struct ModePicker: View {
    var selection: Binding<ScaleStruct>
    
    var body: some View {
        Picker("modifier", selection: selection) {
            ForEach(ScaleModifier.allCases, id: \.self) { modifier in
                Text(modifier.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct ScalePicker: View {
    var selection: Binding<ScaleStruct>
    
    var body: some View {
        Picker("currentScale", selection: selection) {
            ForEach(Scale.keys, id: \.self) { key in
                Text(key.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct ScaleDetailRow: View {
    var scale: ScaleStruct
    var body: some View {
        VStack {
            Text("Scale: \(scale.string)")
                .font(.largeTitle)
                .fontWeight(.bold)
            HStack {
                ForEach(scale.notes, id: \.self) { note in
                    Text(note.rawValue)
                }
            }
        }
        .padding()
    }
}
