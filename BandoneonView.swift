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
    
    var picture : Image { layout.image }
    var size : CGSize { layout.pictureSize }
    var samplePoints : [KeyPosition] { layout.flatten(layout.markerPosition) }
    
    func position(for index: BandoneonKeyIndex) -> CGPoint {
        let position = layout.markerPosition(index: index)!
        return position
    }
    
    var markedNotes: [Note] = Note.allCases
    var octave: Octave?

    var markedKeys: [NoteIndex] {
        var keys = [NoteIndex]()
        for note in markedNotes {
            let indexes = layout.indexesFor(note: note, inOctave: octave)
            for index in indexes {
                keys.append(NoteIndex(note: note, index: index))
            }
        }
        return keys
    }
        
        
    func width(for value: CGFloat, to relativeSize: CGSize? = nil) -> CGFloat {
        return CGFloat(value * (relativeSize?.width ?? self.size.width) / self.size.width)
    }
    
    func height(for value: CGFloat, to relativeSize: CGSize? = nil) -> CGFloat {
        return CGFloat(value * (relativeSize?.height ?? self.size.height) / self.size.height)
    }
    
    let buttonSize = Bandoneon.markerSize
    
    var body: some View {
        ZStack {
            picture
                .resizable()
                .frame(width: size.width, height: size.height)
            ForEach(0 ..< self.markedKeys.count) { index in
                Circle()
                    .fill(Color.blue)
                    .overlay(
                        Text(self.markedKeys[index].note.rawValue)
                            .font(.largeTitle)
                )
                    .frame(
                        width: self.buttonSize.width,
                        height: self.buttonSize.height
                )
                    .position(self.position(for: self.markedKeys[index].index))
                    .offset(x: self.buttonSize.width/2, y: self.buttonSize.height/2)
            }
        }
    }
}

struct BandoneonView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            BandoneonView(layout: Bandoneon.RightSideKeys())
            .rotationEffect(Angle(degrees: 90))
        }
        .scaleEffect(0.4)
        
    }
}
