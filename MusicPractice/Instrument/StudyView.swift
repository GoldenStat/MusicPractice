//
//  StudyView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 28.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ScaleDescriptionView : View {
    var scale: Scale
    var noteNames: [String] { scale.notes.map {$0.rawValue} }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Scale: \(scale.name)")
                    .font(.largeTitle)
                Text("Notes: \(noteNames.joined(separator: "-"))")
                    .font(.title)
                    .fontWeight(.bold)
            }
            Spacer()
        }
    }
}

struct BandoneonHSlide: View {
    
    var playingDirection: PlayingDirection
    var hightlightedNotes: [Note]
    var octaves: [Octave] = []
    
    var body: some View {
        HStack {
            VStack {
                BandoneonView(layout: Bandoneon.layout(.left, playingDirection),
                              notes: hightlightedNotes,
                              octaves: octaves)
            }
            VStack {
                BandoneonView(layout: Bandoneon.layout(.right, playingDirection),
                              notes: hightlightedNotes,
                              octaves: octaves)
            }
        }
    }
}


struct StudyView: View {
    var scale: Scale
    
    @State var playingDirection: PlayingDirection = .open
    
    var body: some View {
        
        VStack {
            
            ScaleDescriptionView(scale: scale)
            
            Divider()
            
            VStack {
                
                HStack {
                    Text(handString.left)
                    Spacer()
                    Text(handString.right)
                }
                .font(.largeTitle)
                
                viewsWithTitle(.open)
                
                viewsWithTitle(.close)
            }
        }
    }
    
    func viewsWithTitle(_ direction: PlayingDirection) -> some View {
        return direction == .open ?
            VStack {
                Text(directionString.open)
                    .fontWeight(.bold)
                BandoneonHSlide(playingDirection: .open,
                                hightlightedNotes: scale.notes)
            } :
            VStack {
                Text(directionString.close)
                    .fontWeight(.bold)
                BandoneonHSlide(playingDirection: .close,
                                hightlightedNotes: scale.notes)
        }
    }
    
    let directionString = (open: PlayingDirection.open.string,
                           close: PlayingDirection.close.string)
    
    let handString = (left: Hand.left.string,
                      right: Hand.right.string)
    
}

struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView(scale: .D7)
    }
}
