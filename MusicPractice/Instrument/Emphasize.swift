//
//  Emphasize.swift
//  MusicPractice
//
//  Created by Alexander Völz on 01.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// a viewbuilder that emphasizes a view
/// in this context it tries to make put a mnemonic(?) frame around it
struct Emphasize<Content: View> : View {
    var content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.flatWhite)
                .clipped()
                .frame(maxHeight: 100)
                .blur(radius: 5)
                .shadow(color: .black, radius: 10.0, x: 8, y: 8)
                .overlay(
                    content
                        .padding()
            )
        }
    }
}

struct Emphasize_Previews: PreviewProvider {
    static var previews: some View {
        Emphasize {
            BandoneonView(layout:
                Bandoneon.layout(.left, .open)
            )
        }
    }
}
