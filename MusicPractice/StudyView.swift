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
    var scaleTitle: String { scale.name }
    var scaleNotes: [Note] { scale.notes }
    var noteNames: [String] { scaleNotes.map {$0.rawValue} }
    
    @State var playingDirection: PlayingDirection = .open
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Scale: \(scaleTitle)")
                        .font(.largeTitle)
                    Text("Notes: \(noteNames.joined(separator: "-"))")
                        .font(.title)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            Divider()
            HStack {
                HStack {
                    VStack {
                        Text("Left Hand")
                            .font(.largeTitle)
                        Text(playingDirection == .open ? "opening" : "closing")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    BandoneonView(layout:
                        Bandoneon.LeftSideKeys(direction: playingDirection),
                                  highlightedNotes: scaleNotes,
                                  octaves: [])
                }
                HStack {
                    BandoneonView(layout:
                        Bandoneon.RightSideKeys(direction: playingDirection),
                                  highlightedNotes: scaleNotes,
                                  octaves: [])

                    VStack {
                        Text("Right Hand")
                            .font(.largeTitle)
                        Text(playingDirection == .open ? "opening" : "closing")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                }
            }
            Divider()
            Picker("", selection: $playingDirection) {
                Text(self.playingDirection == .open ? "abriendo" : "cerrando")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .pickerStyle(SegmentedPickerStyle())
        
        }
    }
}



struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView(scale: Scale.D7)
    }
}
