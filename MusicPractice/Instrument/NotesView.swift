//
//  NotesView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 09.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    
    var musicScale: ScaleStruct
    
    var body: some View {
        VStack(alignment: .leading) {
            musicScale.image
                .resizable()
                .scaledToFit()
        }
    }
}
