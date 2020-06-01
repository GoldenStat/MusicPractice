//
//  BandoneonTecladosView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 01.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

// a view that combines both teclados from the bandoneon in the give movement direction


struct BandoneonTecladosView: View {

    var direction: PlayingDirection = .open
    var highlighted: [Note]
    
    init(_ dir: PlayingDirection, highlightedScale: Scale) {
        self.direction = dir
        self.highlighted = highlightedScale.notes
    }
    
    var body: some View {
        HStack {
            BandoneonView(layout: Bandoneon.LeftKeyLayout(direction: direction))
            BandoneonView(layout: Bandoneon.RightKeyLayout(direction: direction))
        }
    }
}

struct BandoneonTecladosView_Previews: PreviewProvider {
    static var previews: some View {
        BandoneonTecladosView(.open, highlightedScale: Scale.C7)
    }
}
