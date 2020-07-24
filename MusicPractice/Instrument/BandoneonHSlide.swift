//
//  BandoneonHSlide.swift
//  MusicPractice
//
//  Created by Alexander Völz on 01.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BandoneonHSlide: View {
    var playingDirection: PlayingDirection
    var hightlightedNotes: [Note] = []
    var octaves: [Octave] = []
    
    var body: some View {
        HStack {
            Clip {
                
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
}

struct BandoneonHSlide_Previews: PreviewProvider {
    static var previews: some View {
        BandoneonHSlide(playingDirection: .close)
    }
}
