//
//  PositionTesting.swift
//  MusicPractice
//
//  Created by Alexander Völz on 14.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BandoneonView: View {
    let layout : KeyLayout
    var notes: [Note]? // parameter with keys that should be highlighted, no key means no key is highlighted
    var octaves: [Octave]? // if no octave is given, mark all octaves
            
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                /// Picture of the Bandoneon Image
                Image(self.layout.imageName)
                    .resizable()
                
                /// the labels for the keys
                labels(mappedTo: geometry.size)
            }
            .aspectRatio(self.layout.pictureRatio, contentMode: .fit)

        }
    }
    
    func labels(mappedTo size: CGSize) -> some View {
        
        let noteIndexes: [NoteIndex] = layout.noteIndexes(for: notes ?? Note.allCases,
                                                          inOctaves: octaves ?? layout.octaves)
 
        let buttonSize = Bandoneon.markerSize.mapped(from: layout.pictureSize,
                                                        to: size)
        
        var fontSize : CGFloat { min(buttonSize.height, buttonSize.width)/2 }

        return ZStack {
            ForEach(noteIndexes) { noteIndex in
                Circle()
                    .fill(noteIndex.color)
                    .overlay(
                        Text(noteIndex.description)
                            .font(.system(size: fontSize))
                            .fixedSize(horizontal: true, vertical: false)
                )
                    .frame(
                        width: buttonSize.width,
                        height: buttonSize.height
                )
                    .position(layout.position(forKey: noteIndex, with: size))
                    .offset(x: buttonSize.width/2, y: buttonSize.height/2)
            }
        }
    }

}


struct BandoneonView_Previews: PreviewProvider {
    static var previews: some View {
        BandoneonView(layout: Bandoneon.layout(.left, .close),notes: [ .c, .e, .g])
        .padding()
    }
}
