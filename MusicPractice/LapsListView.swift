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
    
    
    let header = [ "started", "ended", "elapsed" ]
    var body: some View {
        VStack {
            if numberOfLaps > 0 {
                TextRowView(row: header)
                    .font(.headline)
            }
            Section {
                ForEach(self.laps, id: \.self.start) { lap in
                    TextRowView(row: [ lap.from.string, lap.to.string, lap.elapsed.string])
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
        LapsListView()
    }
}
