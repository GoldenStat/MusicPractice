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
    
    var body: some View {
        ZStack {
            VStack {
                
                /// show the notes for the current selection
                ScaleDetailRow(scale: scale)
                
                /// show a picker which scale to select
                KeyPicker(key: $scale.key)
                MoodPicker(mood: $scale.mood)
                
                Divider()
                
                ScrollView() {
                    AllBandoneonViews(scale: scale, disabled: true)
                        .animation(nil)
                }
                
                TaskControlBar(taskName: scale.description)
            }
            
        }
        .padding(.horizontal)
        .animation(.default)
    }
    
    func recordLaps() {
        
    }
    
    func load(_ scale: ScaleStruct) {
        print("loading sessions for: ", scale.description)
    }
}

struct PracticeScaleView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeScaleView(scale: Scale.C7)
    }
}
