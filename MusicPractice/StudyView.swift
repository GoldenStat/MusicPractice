//
//  StudyView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 28.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct NavigationStudyView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(Scale.DominantScales.allCases, id: \.self) { dominant in
                    NavigationLink(destination:
                        StudyView(scale: Scale(dominant: dominant))
                    ) {
                        Text(dominant.rawValue)
                    }
                }
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
            
            BandoneonHSlide(playingDirection: .open,
                            hightlightedNotes: scale.notes,
                            octaves: [])
            
            Divider()
            
            BandoneonHSlide(playingDirection: .close,
                            hightlightedNotes: scale.notes,
                            octaves: [])
            Spacer()
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
                BandoneonView(layout: Bandoneon.LeftKeyLayout(direction: playingDirection),
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


struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStudyView()
    }
}
