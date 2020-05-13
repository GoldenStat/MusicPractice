//
//  ContentView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedScale = Scale.C7
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Available scales")
                ForEach(Scale.selectableScales, id: \.self) { dominant in
                    NavigationLink(dominant.rawValue, destination: PracticeScaleView(currentScale: Scale(dominant: dominant))
                    )
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
