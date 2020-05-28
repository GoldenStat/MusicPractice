//
//  StudyView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 28.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct StudyView: View {
    var scale: Scale
    
    @State var playingDirection: PlayingDirection = .open
    
    var body: some View {
        VStack {
            ScaleDescriptionView(scale: scale)
            Divider()
            
            BandoneonHSlide(playingDirection: playingDirection,
                            hightlightedNotes: scale.notes,
                            octaves: [])
            
            Divider()
            PlayDirectionButton(direction: $playingDirection)
        }
    }
}

struct BandoneonHSlide: View {
    
    var playingDirection: PlayingDirection
    var hightlightedNotes: [Note]
    var octaves: [Octave]
    
    var body: some View {
        HStack {
            VStack {
                PlayingStatus(hand: .left, playingDirection: playingDirection)
                BandoneonView(layout: Bandoneon.LeftKeyLayOut(direction: playingDirection),
                              highlightedNotes: hightlightedNotes,
                              octaves: octaves)
            }
            VStack {
                PlayingStatus(hand: .right, playingDirection: playingDirection)
                BandoneonView(layout: Bandoneon.RightKeyLayout(direction: playingDirection),
                              highlightedNotes: hightlightedNotes,
                              octaves: octaves)
            }
        }
    }
}

struct PlayingStatus: View {
    var hand: Hand
    var playingDirection: PlayingDirection
        
    var body: some View {
        VStack {
            Text(hand.string)
                .font(.largeTitle)
            Text(playingDirection.string)
                .font(.subheadline)
                .fontWeight(.bold)
        }
    }
}

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

struct PlayDirectionButton : View {
    @Binding var direction: PlayingDirection
    
    var body: some View {
        Button(direction.string) {
            self.direction.toggle()
        }
    }
}


struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView(scale: Scale.D7)
    }
}
