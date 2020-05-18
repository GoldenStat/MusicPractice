//
//  PositionTesting.swift
//  MusicPractice
//
//  Created by Alexander Völz on 14.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Color {
//    static let inactive = Color(red: 0, green: 0, blue: 0, opacity: 0.4)
    static let inactive = Color.secondary
    static let marked = Color(red: 255 / 255, green: 228 / 255, blue: 109 / 255, opacity: 0.8)

    static func bandoneonKeyColor(for octave: Octave) -> Color {
        switch octave {
        case .subcontra, .contra, .four, .five:
            return Self.inactive
        case .big:
            return Color(red: 100/255, green: 140 / 255, blue: 110 / 266, opacity: 0.9)
        case .small:
            return Color(red: 140/255, green: 140 / 255, blue: 110 / 266, opacity: 0.9)
        case .one:
            return Color(red: 180/255, green: 140 / 255, blue: 100 / 266, opacity: 0.6)
        case .two:
            return Color(red: 200/255, green: 140 / 255, blue: 50 / 266, opacity: 0.6)
        case .three:
            return Color(red: 220/255, green: 140 / 255, blue: 100 / 266, opacity: 0.6)
        }
        
    }
}

struct BandoneonView: View {
    
    let layout : KeyLayout
    var highlightedNotes: [Note] = [] // parameter with keys that should be highlighted, no key means no key is highlighted
    
    var octaves: [Octave] // if no octave is given, mark all octaves

    var picture : Image { layout.image }
    var size : CGSize { layout.pictureSize }
    var samplePoints : [KeyPosition] { layout.flatten(layout.markerPosition) }
        
    func position(for index: Int) -> CGPoint {
        guard markedKeys.isValid(index: index) else { fatalError("Index out of bounds") }
        let bandoneonIndex = markedKeys[index].index
        
        return layout.markerPosition(index: bandoneonIndex)!
    }

    /// searches for notes in `highlightedNotes`that match `octaves` in layout and
    /// returns their `NoteIndex`es. If `octaves` is empty, `NoteIndex`es for all matching `notes` are returned
    var markedKeys: [NoteIndex] {
        return layout.orderedIndexSet(for: highlightedNotes, inOctaves: octaves)
    }
            
    let buttonSize = Bandoneon.markerSize
    
    func color(for key: NoteIndex) -> Color {
        if let octave = key.octave {
            return Color.bandoneonKeyColor(for: octave)
        } else {
            return Color.inactive
        }
    }
    
    var body: some View {
        ZStack {
            picture
                .resizable()
                .frame(width: size.width, height: size.height)
            ForEach(0 ..< self.markedKeys.count) { index in
                Circle()
                    .fill(self.color(for: self.markedKeys[index]))
                    .overlay(
                        Text(self.markedKeys[index].string)
                            .font(.largeTitle)
                )
                    .frame(
                        width: self.buttonSize.width,
                        height: self.buttonSize.height
                )
                    .position(self.position(for: index))
                    .offset(x: self.buttonSize.width/2, y: self.buttonSize.height/2)
            }
        }
    }
}

struct BandoneonView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            BandoneonView(layout: Bandoneon.LeftSideKeys(), highlightedNotes: [], octaves: [])
            .rotationEffect(Angle(degrees: 90))
        }
        .scaleEffect(0.4)
        
    }
}
