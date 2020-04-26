//
//  ContentView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var scale: Scale = .C7
    
    var body: some View {
        NavigationView {
            PracticeScaleView(selectedScale: scale.scale)
            .navigationBarTitle("Scale Practice")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
