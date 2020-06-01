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
    
    var body: some View {
        VStack {
            Frame(isInvisible: true) {
                BandoneonView(layout: BandoneonLayout[framedBandoneon])
            }
            .padding()
            VStack {
                HStack {
                    FramedBandoneon(initialIndex: 0, boundTo: $framedBandoneon)
                    FramedBandoneon(initialIndex: 1, boundTo: $framedBandoneon)
                }
                HStack {
                    FramedBandoneon(initialIndex: 2, boundTo: $framedBandoneon)
                    FramedBandoneon(initialIndex: 3, boundTo: $framedBandoneon)

                }
            }
        }
    }
}

struct FramedBandoneon: View {
    
    var initialIndex: Int
    @Binding var boundTo: Int

    var body: some View {
        Frame(isInvisible: initialIndex != boundTo) {
            BandoneonView(layout: BandoneonLayout[initialIndex])
                .onTapGesture {
                    self.boundTo = self.initialIndex
            }
        }
    }
}

struct AllBandoneonView_Previews: PreviewProvider {
    static var previews: some View {
        AllBandoneonViews()
    }
}
