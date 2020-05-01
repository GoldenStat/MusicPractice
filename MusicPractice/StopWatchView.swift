//
//  PracticeScaleView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Color {
    static let flatWhite = Color(red: 255 / 255, green: 255 / 255, blue: 230 / 255)
}


struct StopWatchView: View {
    
    @ObservedObject var stopWatch = StopWatch()
    var isRunning: Bool { stopWatch.isRunning }
    var time: String { stopWatch.counter.string }
    
    var wrappedString = (on: "Start", off: "Pause")
    
    var body: some View {
        VStack {
            LapsListView(laps: stopWatch.laps)
            
            VStack {
                Text(time)
                    .font(.title)
        
                HStack {
                    
                    Button( isRunning ? wrappedString.off : wrappedString.off ) {
                      self.stopWatch.toggleStopStart()
                    }
                    .buttonStyle(StopWatchButtonStyle(
                        color: (on: .green, off: .red),
                        isRunning: isRunning))
                    
                    StopWatchButton(stopWatch: stopWatch,
                                    string: (on: "Start", off: "Pause"),
                                    color: (on: .green, off: .red))
                    { self.stopWatch.toggleStopStart() }
                    
                    StopWatchButton(stopWatch: stopWatch,
                                    string: (on: "Reset", off: "Lap"),
                                    color: (on: .orange, off: .yellow))
                    { self.stopWatch.toggleLapReset() }
                    
                }
            }
            .padding()
        }
    }
    
}

struct StopWatchButton: View {

    @ObservedObject var stopWatch : StopWatch

    let string: (on: String, off: String)
    let color: (on: Color, off: Color)

    var isRunning: Bool { stopWatch.isRunning }

    let action : () -> ()

    var wrappedString: String { isRunning ? string.off : string.on }
    var wrappedColor: Color { isRunning ? color.off : color.on }

    var body: some View {
        Button(wrappedString.capitalized) {
            self.action()
        }
        .buttonStyle(ScaleButtonStyle(color: wrappedColor))
    }

}


struct StopWatchButtonStyle: ButtonStyle {
    
    let color: (on: Color, off: Color)
    
    var isRunning: Bool

    var wrappedColor: Color { isRunning ? color.off : color.on }

    func makeBody(configuration: Self.Configuration) -> some View {
        Circle()
            .fill(wrappedColor)
            .overlay(
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .padding(4)
        )
            .overlay(configuration.label
                .foregroundColor(.white)
        )
            .frame(maxWidth: 75, maxHeight: 75)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    
    let color: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Circle()
            .fill(color)
            .overlay(
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .padding(4)
        )
            .overlay(configuration.label
                .foregroundColor(.white)
        )
            .frame(maxWidth: 75, maxHeight: 75)
    }
}


struct LapsListView : View {
    var laps: [Lap]
    
    var numberOfLaps: Int { laps.count }
    var areLapsRecorded: Bool { numberOfLaps > 0 }
    
    
    let header = [ "started", "ended", "elapsed" ]
    var body: some View {
        VStack {
            if numberOfLaps > 0 {
                TitleView(row: header)
                    .font(.headline)
            }
            Section {
                ForEach(self.laps, id: \.self.start) { lap in
                    TitleView(row: [ lap.from.string, lap.to.string, lap.elapsed.string])
                }
            }
        }
        .padding()
    }
}

struct TitleView: View {
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

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopWatchView()
    }
}
