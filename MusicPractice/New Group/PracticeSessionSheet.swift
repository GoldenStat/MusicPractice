//
//  PracticeSessionSheet.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PracticeSessionSheet: View {
    let title: String = "Start a New Practice session"
    
    struct SessionInfo {
        var scaleName: String = "New Session"
    }
    
    @State var info: SessionInfo = SessionInfo()
    
    var body: some View {
        VStack {
            Text(title)
            Form {
                HStack {
                    Label("Scale:", systemImage: "notes")
                    TextField("scale", text: $info.scaleName)
                }
            }
        }
    }
}

struct PracticeSessionSheet_Previews: PreviewProvider {
    static var previews: some View {
        PracticeSessionSheet()
    }
}
