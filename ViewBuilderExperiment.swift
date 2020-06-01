//
//  ViewBuilderExperiment.swift
//  MusicPractice
//
//  Created by Alexander Völz on 01.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI


struct ViewBuilderExperiment: View {
    var body: some View {
        HStack {
            Text("Hello")
            Text("World!")
        }
    }
}



struct CalendarView<DateView> : View where DateView: View {
    let interval: DateInterval
    let content: (Date) -> DateView
    
    init(interval: DateInterval, @ViewBuilder content: @escaping(Date)-> DateView) {
        self.interval = interval
        self.content = content
    }
    
    var body: some View {
        Text("Hello")
    }
}


struct ViewBuilderExperiment_Previews: PreviewProvider {
    static var previews: some View {
        ViewBuilderExperiment()
    }
}
