//
//  PracticeScaleView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 26.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PracticeScaleView: View {
    
    @State var selectedScale: MusicScale { didSet { load(selectedScale) } }
    
    var body: some View {
        ZStack {
            
            Color.flatWhite
                .edgesIgnoringSafeArea(.all)
        VStack {
            Text("Choose a scale to practice")
            
            /// show a picker which scale to select
//            Text("current Scale: D7")
            Picker("currentScale", selection: $selectedScale) {
                ForEach(MusicScale.allCases, id: \.self) { scale in
                    Text(scale.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            /// upon selection, show a summary of progress so far
            /// load History()
            /// upon selection, show a timer button, show time how long this scale is being practiced

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
        PracticeScaleView(selectedScale: Scale.C7.scale)
    }
}
