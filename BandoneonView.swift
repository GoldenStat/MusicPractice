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
        case .subcontra, .contra, .big, .four, .five:
            return Self.inactive
        case .small:
            return Color(red: 160/255, green: 80 / 255, blue: 109 / 266, opacity: 0.7)
        case .one:
            return Color(red: 180/255, green: 100 / 255, blue: 109 / 266, opacity: 0.7)
        case .two:
            return Color(red: 200/255, green: 120 / 255, blue: 109 / 266, opacity: 0.7)
        case .three:
            return Color(red: 255/255, green: 140 / 255, blue: 109 / 266, opacity: 0.7)
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

    /// "holds" all the NoteIndexes that are held in `highlightedNotes`
    var markedKeys: [NoteIndex] {
        var keys = [NoteIndex]()
        if octaves.isEmpty {
            for note in highlightedNotes {
                let indexes : [BandoneonKeyIndex] = layout.indexesFor(note: note, inOctave: nil)
                for index in indexes {
                    keys.append(NoteIndex(note: note, index: index, octave: nil))
                }
            }
        } else {
            for octave in octaves {
                for note in highlightedNotes {
                    let indexes = layout.indexesFor(note: note, inOctave: octave)
                    for index in indexes {
                        keys.append(NoteIndex(note: note, index: index, octave: octave))
                    }
                }
            }
        }
        return keys
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
//                    .fill(Color.inactive)
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
            BandoneonView(layout: Bandoneon.RightSideKeys(), highlightedNotes: [Note.c], octaves: [])
            .rotationEffect(Angle(degrees: 90))
        }
        .scaleEffect(0.4)
        
    }
}
