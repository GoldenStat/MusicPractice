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
    var notes: [Note] = [] // parameter with keys that should be highlighted, no key means no key is highlighted
    var octaves: [Octave] = [] // if no octave is given, mark all octaves
            
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                /// Picture of the Bandoneon Image
                Image(self.layout.imageName)
                    .resizable()
                
                /// the labels for the keys
                self.keyLabels(for: self.notes, mappedTo: geometry.size)
            }
            .aspectRatio(self.layout.pictureRatio, contentMode: .fit)

        }
    }
    
    /// re-calculate key Positions base on frame Size
    func keyLabels(for notes: [Note], mappedTo newSize: CGSize) -> some View {
        
        let newButtonSize = Bandoneon.markerSize
            .mapped(from: layout.pictureSize,
                    to: newSize)
        
        var fontSize : CGFloat { min(newButtonSize.height, newButtonSize.width)/2 }
        
        /// searches for notes in `notes`that match `octaves` in layout and
        /// returns their `NoteIndex`es. If `octaves` is empty, `NoteIndex`es for all matching `notes` are returned
        var markedKeys: [NoteIndex] {
            return layout.orderedIndexSet(for: notes, inOctaves: octaves)
        }
        
        func highlight(keyAt index: Int) -> some View {
            let key = markedKeys[index]
            return Circle()
                .fill(key.color)
                .overlay(
                    Text(key.string)
                        .font(.system(size: fontSize))
                        .fixedSize(horizontal: true, vertical: false)
            )
                .frame(
                    width: newButtonSize.width,
                    height: newButtonSize.height
            )
                .position(layout.position(forKey: key, with: newSize))
                .offset(x: newButtonSize.width/2, y: newButtonSize.height/2)
        }
        
        return ForEach(0 ..< markedKeys.count) { index in
            highlight(keyAt: index)
        }
    }
}


struct BandoneonView_Previews: PreviewProvider {
    static var previews: some View {
        BandoneonView(layout: Bandoneon.layout(.right, .open))
        .padding()
    }
}
