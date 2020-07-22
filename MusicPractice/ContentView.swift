//
//  ContentView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
//    var selectedKey : ScaleStruct =
//        ScaleStruct(key: .C, mood: .dominant)
//
    var body: some View {
        ZStack {
            Background()
            PracticeSessionView()
//            PracticeScaleView(scale: selectedKey)
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
