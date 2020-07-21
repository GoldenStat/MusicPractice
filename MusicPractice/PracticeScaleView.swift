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
                
                ScrollView() {
                    /// show a picker which scale to select
                    KeyPicker(key: $scale.key)
                    MoodPicker(mood: $scale.mood)
                    
                    /// show the notes for the current selection
                    ScaleDetailRow(scale: scale)
                    
                    Divider()
                    
//                    Emphasize {
                        AllBandoneonViews(scale: scale)
//                    }
                }
            }
            
            VStack {
                
                Spacer()
                ControlButtonsView(recorder: recorder, stopWatch: StopWatch(), scale: scale)
//                AudioTrackTimerView(recorder: recorder, scale: $scale)
            }
        }
        .padding(.horizontal)
        .statusBar(hidden: true)
    }
    
    
    func recordLaps() {
        
    }
    
    func load(_ scale: ScaleStruct) {
        print("loading sessions for: ", scale.description)
    }
}

struct MoodPicker: View {
    @Binding var mood: ScaleModifier
    
    var body: some View {
        Picker("modifier", selection: $mood) {
            ForEach(ScaleModifier.allCases, id: \.self) { modifier in
                Text(modifier.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct KeyPicker: View {
    @Binding var key: ScaleKey
    
    var body: some View {
        Picker("currentScale", selection: $key) {
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
        
        HStack {
            VStack(alignment: .trailing) {
                Text("Scale: \(scale.description)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                HStack {
                    ForEach(scale.notes, id: \.self) { note in
                        Text(note.rawValue)
                    }
                    .font(.headline)
                }
            }
            Spacer()
            NotesView(scale: scale)
        }
        .padding()
    }
}



struct PracticeScaleView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeScaleView(scale: Scale.C7)
    }
}
