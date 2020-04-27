//
//  SoundBarView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 27.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

let numberOfSamples = 10

struct SoundBarView: View {
    
    var value: CGFloat
    
    var body: some View {
        GeometryReader { geom in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom))
                    .frame(width: ( geom.size.width - CGFloat(numberOfSamples) * 4 ) / CGFloat(numberOfSamples), height: self.value)
            }
        }
    }
}

struct SoundBarView_Previews: PreviewProvider {
    static var previews: some View {
        SoundBarView(value: 200.0)
    }
}
