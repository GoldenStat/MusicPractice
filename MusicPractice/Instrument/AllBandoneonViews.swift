//
//  AllBandoneonView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 29.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BandoneonLayout {
    static var layout : [KeyLayout] = [
        Bandoneon.layout(.left, .open),
        Bandoneon.layout(.left, .close),
        Bandoneon.layout(.right, .open),
        Bandoneon.layout(.right, .close)
    ]
    
    static subscript(index: Int) -> KeyLayout {
        guard (0 ..< Self.layout.count).contains(index) else { fatalError("BandoneonLayout doesn't have \(index) members")
        }
        return Self.layout[index]
    }
    
}

struct AllBandoneonViews: View {
    @State var index: Int = 0
    
    var body: some View {
        VStack {
            BandoneonView(layout: BandoneonLayout[index])
                .padding()
            VStack {
                HStack {
                    FramedBandoneon(initialIndex: 0, boundTo: $index)
                    FramedBandoneon(initialIndex: 2, boundTo: $index)
                }
                HStack {
                    FramedBandoneon(initialIndex: 1, boundTo: $index)
                    FramedBandoneon(initialIndex: 3, boundTo: $index)

                }
            }
        }
    }
}

struct FramedBandoneon: View {
    
    var initialIndex: Int
    @Binding var boundTo: Int

    var body: some View {
        StaticFrame(isInvisible: initialIndex != boundTo) {
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
