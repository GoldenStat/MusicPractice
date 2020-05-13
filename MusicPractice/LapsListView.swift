//
//  LapsListView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 02.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct LapsListView : View {
    var laps: [Lap] = []
    
    var numberOfLaps: Int { laps.count }
    var areLapsRecorded: Bool { numberOfLaps > 0 }
        
    var body: some View {
        VStack {
            if areLapsRecorded {
                Section(header: TextRowView(row: [ "Date", "Session" ])
                    .font(.headline)
                ) {
                    ForEach(self.laps, id: \.self) { lap in
                        TextRowView(row: [ lap.dateString, lap.duration ])
                            .font(.system(size: 24))
                    }
                }
            }
        }
        .padding()
    }
}

struct TextRowView: View {
    let row: [String]
    var titleCount : Int { row.count }
    
    var body: some View {
        HStack {
            ForEach ( 0 ..< titleCount ) { index in
                if index > 0 {
                    Spacer()
                }
                Text(self.row[index])
            }
            
        }
        
    }
}


struct LapsListView_Previews: PreviewProvider {
    static var previews: some View {
        LapsListView(laps: Lap.sampleLaps)
    }
}
