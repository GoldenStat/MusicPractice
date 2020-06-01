//
//  ContentView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var selectedKey : ScaleKey = Scale.keys[0]
    @State var selectedModifier : ScaleModifier
    
    var body: some View {
        PracticeScaleView(currentKey: selectedKey, modifier: .currentModifier))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
