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
    
    //    var samplePoints : [KeyPosition] { layout.flatten(layout.markerPosition) }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                /// Picture of the Bandoneon Image
                Image(self.layout.imageName)
                    .resizable()
                    .scaledToFit()
                //                    .frame(width: size.width, height: size.height)
                
                /// the labels for the keys
                self.keyLabels(for: self.highlightedNotes, mappedTo: geometry.size)
            }
        }
    }
    
    /// re-calculate key Positions base on frame Size
    func keyLabels(for notes: [Note], mappedTo newSize: CGSize) -> some View {
        
        let originalSize: CGSize = layout.pictureSize
        let scaleFactor = CGPoint(x: newSize.height / originalSize.height,
                                  y: newSize.width / originalSize.width)
        
        let newButtonSize = CGSize(width: Bandoneon.markerSize.width * scaleFactor.x,
                                   height: Bandoneon.markerSize.height * scaleFactor.y)
        
        /// searches for notes in `highlightedNotes`that match `octaves` in layout and
        /// returns their `NoteIndex`es. If `octaves` is empty, `NoteIndex`es for all matching `notes` are returned
        var markedKeys: [NoteIndex] {
            return layout.orderedIndexSet(for: notes, inOctaves: octaves)
        }
        
        /// get the Position for the index of a key
        func position(for index: Int) -> CGPoint {
            guard markedKeys.isValid(index: index) else { fatalError("Index out of bounds") }
            let bandoneonIndex = markedKeys[index].index
            
            let oldPosition = layout.markerPosition(index: bandoneonIndex)!
            let newPosition = CGPoint(x: oldPosition.x * scaleFactor.x, y: oldPosition.y*scaleFactor.y)
            return newPosition
        }
        
        /// determine the color for a key based on its pitch and if the key had an octave assigned
        func color(for key: NoteIndex) -> Color {
            if let octave = key.octave {
                return Color.bandoneonKeyColor(for: octave)
            } else {
                return Color.inactive
            }
        }
        
        return ForEach(0 ..< markedKeys.count) { index in
            Circle()
                .fill(color(for: markedKeys[index]))
                .overlay(
                    Text(markedKeys[index].string)
                        .font(.largeTitle)
                    
            )
                .frame(
                    width: newButtonSize.width,
                    height: newButtonSize.height
            )
                .position(position(for: index))
            //                    .offset(x: newButtonSize.width/2, y: newButtonSize.height/2)
        }
        
    }
    
}

struct BandoneonBothSides: View {
    
    @State var direction: PlayingDirection
    var directionName : String { direction == .open ? "Open" :  "Close" }
    
    var body: some View {
        VStack {
            BandoneonView(layout: Bandoneon.LeftSideKeys(direction: direction), highlightedNotes: [], octaves: [])
            BandoneonView(layout: Bandoneon.RightSideKeys(direction: direction), highlightedNotes: [], octaves: [])
            BandoneonView(layout: Bandoneon.LeftSideKeys(direction: direction), highlightedNotes: [], octaves: [])
            BandoneonView(layout: Bandoneon.RightSideKeys(direction: direction), highlightedNotes: [], octaves: [])
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
        BandoneonView(layout: Bandoneon.LeftSideKeys(direction: .open))
//        HStack {
//            BandoneonBothSides(direction: .close)
//            BandoneonBothSides(direction: .open)
//        }
    }
}
