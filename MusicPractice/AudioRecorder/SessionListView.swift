//
//  SessionListView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 16.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI



struct SessionListView: View {
    
    var scaleName: String
    var practiceDuration: String
    var recordingLength: String
    var date: String
    
    var body: some View {
//        List() {
//            Section(scaleName)
//            HStack {
//                Text(date)
//                Text(recordingLength)
                Text(practiceDuration)
//            }
//        }
    }
}


struct SessionListView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView(scaleName: Scale.C7.description, practiceDuration: "20:00", recordingLength: "00:20", date: "2020-05-14")
    }
}
