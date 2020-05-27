//
//  CloudTrackView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 27.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct CloudTrackView: View {
    var body: some View {
        ZStack {
            
            Color.gray
            
            VStack(spacing: 10) {
                Text("Submitting...")
                    .font(.title)
                
//                UIActivityIndicatorView(style: .large)
//                .startAnimating()
            }
        }
    }
}

struct CloudTrackView_Previews: PreviewProvider {
    static var previews: some View {
        CloudTrackView()
    }
}
