//
//  AllBandoneonView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 29.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct AllBandoneonViews: View {
    @State var index: Int = 0

    static var layout : [KeyLayout] = [
        Bandoneon.layout(.left, .open),
        Bandoneon.layout(.left, .close),
        Bandoneon.layout(.right, .open),
        Bandoneon.layout(.right, .close)
    ]
                    
    var body: some View {
        VStack {
            BandoneonView(layout: Self.layout[index])
                .padding()
            VStack {
                HStack {
                    MarkedBandoneonView(marked: index == 0, layout: Self.layout[0])
                        .onTapGesture {
                            self.index = 0
                    }
                    MarkedBandoneonView(marked: index == 2, layout: Self.layout[2])
                        .onTapGesture {
                            self.index = 2
                    }
                }
                HStack {
                    MarkedBandoneonView(marked: index == 1, layout: Self.layout[1])
                        .onTapGesture {
                            self.index = 1
                    }

                    MarkedBandoneonView(marked: index == 3, layout: Self.layout[3])
                        .onTapGesture {
                            self.index = 3
                    }

                }
            }
        }
    }
}

struct AllBandoneonView_Previews: PreviewProvider {
    static var previews: some View {
        AllBandoneonViews()
    }
}
