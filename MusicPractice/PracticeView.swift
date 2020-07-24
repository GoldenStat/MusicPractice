//
//  PracticeScaleView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 26.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PracticeTaskView: View {
    
    @State var task: TaskRecord // the task we will append this result to
    @State var resultRecord: ResultRecord? = nil
    
    func addRecordToTask() {
        task.result = resultRecord // "save" button
    }
    
    var scale: ScaleStruct { task.scale }
    
    var body: some View {
        ZStack {
            VStack {
                
                /// show the notes for the current selection
                ScaleDetailRow(scale: scale)
                
                /// show a picker which scale to select
                KeyPicker(key: $task.scale.key)
                MoodPicker(mood: $task.scale.mood)
                
                Divider()
                
                GeometryReader { geometry in
                    ScrollView(.horizontal) {
                        HStack {
                            VStack {
                                Text("Abriendo")
                                BandoneonView(layout: BandoneonLayout.leftOpening, notes: scale.notes)
                                BandoneonView(layout: BandoneonLayout.rightOpening, notes: scale.notes)
                            }
                            .frame(width: geometry.size.width)
                            VStack {
                                Text("Cerrando")
                                BandoneonView(layout: BandoneonLayout.leftClosing, notes: scale.notes)
                                BandoneonView(layout: BandoneonLayout.rightClosing, notes: scale.notes)
                            }
                            .frame(width: geometry.size.width)
                        }
                        .font(.title)
                    }
                }
            }
            
            VStack {
                
                Spacer()
//                AudioTrackTimerView(recorder: recorder, scale: $scale)
//                ControlButtonsView(recorder: recorder, stopWatch: StopWatch(), scale: scale)
                
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


struct PracticeTaskView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeTaskView(task: TaskRecord(scale: Scale.C7))
    }
}
