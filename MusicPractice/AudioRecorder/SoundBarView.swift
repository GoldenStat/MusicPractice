//
//  SoundBarView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 27.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct SoundBarView: View {
    
    var value: CGFloat
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue, .blue, .purple]), startPoint: .top, endPoint: .bottom))
                .frame(height: value)
        }
    }
}


struct SoundBarView_Previews: PreviewProvider {
    static var samples = 15
    static var amplitude = 20.0
    
    static var previews: some View {
        
        VStack {
            Text("Soundbar samples")
                .font(.title)
            HStack {
                ForEach(0 ..< samples) { index in
                    SoundBarView(value: CGFloat(amplitude*Double(index)))
                }
                ForEach(0 ..< samples) { index in
                    SoundBarView(value: CGFloat(amplitude*Double((samples-index))))
                }
            }
            .padding()
        }
    }
}
