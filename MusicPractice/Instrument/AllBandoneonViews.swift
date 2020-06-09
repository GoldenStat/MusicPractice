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
    
    var body: some View {
        VStack {
            if zoom {
                Frame(isInvisible: true) {
                    BandoneonView(layout: BandoneonLayout[framedBandoneon])
                }
                .padding()
            }
            VStack {
                HStack {
                    FramedBandoneon(initialIndex: 0, boundTo: $framedBandoneon, scale: scale)
                    FramedBandoneon(initialIndex: 1, boundTo: $framedBandoneon, scale: scale)
                }
                HStack {
                    FramedBandoneon(initialIndex: 2, boundTo: $framedBandoneon, scale: scale)
                    FramedBandoneon(initialIndex: 3, boundTo: $framedBandoneon, scale: scale)

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

    var body: some View {
        Frame(isInvisible: initialIndex != boundTo) {
            BandoneonView(layout: BandoneonLayout[initialIndex],
                          notes: notes)
                .onTapGesture {
                    self.boundTo = self.initialIndex
            }
        }
    }
}

struct AllBandoneonView_Previews: PreviewProvider {
    static var previews: some View {
        AllBandoneonViews(scale: Scale.C7)
    }
}
