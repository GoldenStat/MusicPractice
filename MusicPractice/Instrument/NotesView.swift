//
//  NotesView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 09.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    
    var scale: ScaleStruct
    
    var body: some View {
        VStack(alignment: .leading) {
            scale.image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 310.0)
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeScaleView(scale: Scale.C7)
//        NotesView(scale: Scale.C7)
    }
}
