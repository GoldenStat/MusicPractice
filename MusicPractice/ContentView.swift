//
//  ContentView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            ZStack {
                Background()
                TaskControlBar(taskName: Scale.C7.description,
                               controls: .init(showRecordings: true,
                                               showLaps: true,
                                               showTimer: true))
                //                PracticeSessionView()
            }
        }
    }
}

struct Background: View {
    var body: some View {
        Color.flatWhite
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
