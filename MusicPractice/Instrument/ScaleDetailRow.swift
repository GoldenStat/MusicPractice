//
//  ScaleDetailRow.swift
//  MusicPractice
//
//  Created by Alexander Völz on 21.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ScaleDetailRow: View {
    
    var scale: ScaleStruct
    
    @ViewBuilder var body: some View {
        if UIDevice.current.orientation.isLandscape {
            HStack {
                VStack(alignment: .trailing) {
                    Text("Scale: \(scale.description)")
                        .font(.title)
                        .fontWeight(.bold)
                    HStack {
                        ForEach(scale.notes, id: \.self) { note in
                            Text(note.rawValue)
                        }
                        .font(.headline)
                    }
                    .animation(nil)
                }
                Spacer()
                NotesView(musicScale: scale)
            }
            .padding()
        } else {
            VStack {
                HStack(alignment: .bottom) {
                    Text("Scale: \(scale.description)")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    HStack {
                        ForEach(scale.notes, id: \.self) { note in
                            Text(note.rawValue)
                        }
                        .font(.headline)
                    }
                    .animation(nil)
                }
                NotesView(musicScale: scale)
            }
            .padding()
        }
    }
}


struct ScaleDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        ScaleDetailRow(scale: Scale.C7)
    }
}
