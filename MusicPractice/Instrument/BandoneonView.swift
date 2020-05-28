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
    var octaves: [Octave] = [] // if no octave is given, mark all octaves
        
    func width(ofSize: CGSize) -> CGFloat { ofSize.width }
    func height(ofSize: CGSize) -> CGFloat { ofSize.height }

    var sampleSize : CGSize { layout.pictureSize }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
            /// Picture of the Bandoneon Image
            Image(self.layout.imageName)
                .resizable()
                .coordinateSpace(name: "KeyLayout")

                    /// the labels for the keys
                self.keyLabels(for: self.highlightedNotes, mappedTo: geometry.frame(in: .named("KeyLayout")).size)
            }
            .scaledToFit()

        }
    }
    
    /// re-calculate key Positions base on frame Size
    func keyLabels(for notes: [Note], mappedTo newSize: CGSize) -> some View {
        
        let originalSize: CGSize = layout.pictureSize
        let scaleFactor = CGPoint(x: newSize.width / originalSize.width,
                                  y: newSize.height / originalSize.height)
        
        let newButtonSize = CGSize(width: Bandoneon.markerSize.width * scaleFactor.x,
                                   height: Bandoneon.markerSize.height * scaleFactor.y)
        var fontSize : CGFloat { min(newButtonSize.height, newButtonSize.width)/2 }
        
        /// searches for notes in `highlightedNotes`that match `octaves` in layout and
        /// returns their `NoteIndex`es. If `octaves` is empty, `NoteIndex`es for all matching `notes` are returned
        var markedKeys: [NoteIndex] {
            return layout.orderedIndexSet(for: notes, inOctaves: octaves)
        }
        
        /// get the Position for the index of a key
        func position(forKey key: NoteIndex) -> CGPoint {
            let bandoneonIndex = key.index

            let oldPosition = layout.markerPosition(index: bandoneonIndex)!
            let newPosition = CGPoint(x: oldPosition.x * scaleFactor.x, y: oldPosition.y*scaleFactor.y)

            return newPosition
        }

        func mark(indexKey index: Int) -> some View {
            return Circle()
                .fill(markedKeys[index].note.color)
                .overlay(
                    Text(markedKeys[index].note.string)
                        .font(.system(size: fontSize))
                        .fixedSize(horizontal: true, vertical: false)
            )
                .frame(
                    width: newButtonSize.width,
                    height: newButtonSize.height
            )
                .position(position(forKey: markedKeys[index]))
                .offset(x: newButtonSize.width/2, y: newButtonSize.height/2)
        }
        
        return ForEach(0 ..< markedKeys.count) { index in
            mark(indexKey: index)
        }
    }
}

struct BandoneonBothSides: View {
    
    @State var direction: PlayingDirection
    var directionName : String { direction == .open ? "Open" :  "Close" }
    
    var body: some View {
        VStack {
            BandoneonView(layout: Bandoneon.LeftKeyLayOut(direction: direction), highlightedNotes: [], octaves: [])
            Button(action: {
                self.toggleDirection()
            })
            {
                Text(directionName)
                    .font(.largeTitle)
            }
        }
    }
    
    func toggleDirection() {
        direction = (direction == .open) ? .close : .open
    }
}

struct BandoneonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BandoneonView(layout: Bandoneon.LeftKeyLayOut(direction: .open))
            BandoneonView(layout: Bandoneon.LeftKeyLayOut(direction: .close))
//            BandoneonBothSides(direction: .close)
//            BandoneonBothSides(direction: .open)
        }
    }
}
