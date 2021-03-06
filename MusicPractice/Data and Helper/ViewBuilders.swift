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
//                .frame(maxHeight: 100)
                .frame(minHeight: 100)
                .blur(radius: 5)
                .shadow(color: .black, radius: 10.0, x: 8, y: 8)
                .overlay(
                    content
                        .padding()
            )
        }
    }
}

struct Frame<Content: View> : View {
    var isInvisible: Bool = false
    var content: Content
    
    init(@ViewBuilder content: () -> Content, isInvisible: Bool = false) {
        self.content = content()
        self.isInvisible = isInvisible
    }
    var body: some View {
        content
            .clipShape(
                clipShape()
        )
            .overlay(
                clipShape()
                    .stroke(strokeColor, lineWidth: border)
        )
    }
    
    var strokeColor: Color { isInvisible ? Color.clear : Color.blue }
    let radius : CGFloat = 10
    let border : CGFloat = 4

    func clipShape() -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius)
    }
}

struct Clip<Content: View> : View {
    var framed: Bool = false
    var content: Content
    
    init(@ViewBuilder content: () -> Content, framed: Bool = false) {
        self.content = content()
        self.framed = framed
    }
    var body: some View {
        content
            .clipShape(
                clipShape()
        )
            .overlay(
                clipShape()
                    .stroke(strokeColor, lineWidth: border)
        )
    }
    
    var strokeColor: Color { framed ? Color.blue : Color.clear }
    let radius : CGFloat = 10
    let border : CGFloat = 4

    func clipShape() -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius)
    }
}


struct Emphasize_Previews: PreviewProvider {
    static var previews: some View {
        Frame {
            BandoneonView(layout:
                Bandoneon.layout(.left, .open)
            )
        }
    }
}
