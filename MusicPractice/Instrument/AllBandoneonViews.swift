//
//  AllBandoneonView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 29.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct AllBandoneonViews: View {
    @State var framedBandoneon: Int = 0
    var zoom: Bool = false
    var scale: ScaleStruct?
    var disabled: Bool = false
    
    let layouts : [KeyLayout] = [ BandoneonLayout.leftOpening,
                                  BandoneonLayout.rightOpening,
                                  BandoneonLayout.leftClosing,
                                  BandoneonLayout.rightClosing ]

    var body: some View {
        VStack {
            if zoom {
                Frame(isInvisible: true) {
                    BandoneonView(layout: layouts[framedBandoneon])
                }
                .padding()
            }
            VStack {
                HStack {
                    FramedBandoneon(initialIndex: 0, boundTo: $framedBandoneon, scale: scale, disabled: disabled)
                    FramedBandoneon(initialIndex: 1, boundTo: $framedBandoneon, scale: scale, disabled: disabled)
                }
                HStack {
                    FramedBandoneon(initialIndex: 2, boundTo: $framedBandoneon, scale: scale, disabled: disabled)
                    FramedBandoneon(initialIndex: 3, boundTo: $framedBandoneon, scale: scale, disabled: disabled)
                }
            }
        }
    }
}

struct FramedBandoneon: View {
    
    var notes: [Note] {
        scale?.notes ?? []
    }
    var initialIndex: Int
    @Binding var boundTo: Int
    var scale: ScaleStruct?
    var disabled = false
    
    let layouts : [KeyLayout] = [ BandoneonLayout.leftOpening,
                                  BandoneonLayout.rightOpening,
                                  BandoneonLayout.leftClosing,
                                  BandoneonLayout.rightClosing ]

    @ViewBuilder var body: some View {
        if disabled {
            BandoneonView(layout: layouts[initialIndex],
                          notes: notes)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Frame(isInvisible: initialIndex != boundTo && !disabled) {
                BandoneonView(layout: layouts[initialIndex],
                              notes: notes)
                    .onTapGesture {
                        self.boundTo = self.initialIndex
                    }
            }
        }
    }
}

struct AllBandoneonView_Previews: PreviewProvider {
    static var previews: some View {
        AllBandoneonViews(scale: Scale.C7)
    }
}
