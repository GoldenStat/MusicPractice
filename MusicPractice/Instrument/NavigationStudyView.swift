//
//  NavigationStudyView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 01.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct NavigationStudyView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Pick a scale")
                    .font(.title)
                List {
                    ForEach(Scale.keys, id: \.self) { scaleKey in
                        NavigationLink(destination:
                            StudyView(scale: ScaleStruct(key: scaleKey, mood: .dominant))
                        ) {
                            Text(Scale.string(for: scaleKey, .dominant))
                        }
                    }
                }
            }
        }
    }
}

struct NavigationStudyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStudyView()
    }
}
