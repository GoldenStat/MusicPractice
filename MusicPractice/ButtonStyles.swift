//
//  ButtonStyles.swift
//  MusicPractice
//
//  Created by Alexander Völz on 02.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ButtonTests: View {
    
    @State var isRunning = false
    
    @State var currentStateIndex = 0
    var button1State: PracticeState {
        let allCases = PracticeState.allCases
        return allCases[currentStateIndex % allCases.count]
    }
    
    var body: some View {
        HStack {
            VStack {
                
                ForEach(PracticeState.allCases, id: \.self) { state in
                    Button(state.rawValue) {
                        self.isRunning.toggle()
                    }
                    .buttonStyle(PracticeButtonStyle(state: state, isActive: self.isRunning))
                }
            }
            VStack {
                ForEach(PracticeState.allCases, id: \.self) { state in
                    Button(state.rawValue) {
                        self.isRunning.toggle()
                    }
                    .buttonStyle(PracticeButtonStyle(state: state, isActive: !self.isRunning))
                }
            }
        }
    }
}

enum PracticeState : String, CaseIterable {
    case Pause, Stop, Start, Lap, Reset, Store, REC
}

struct PracticeButtonStyle: ButtonStyle {

    var state: PracticeState
    var isActive: Bool = true
    func color(forState state: PracticeState) -> Color {
        switch state {
        case .Pause: return .red
        case .Stop: return .red
        case .Start: return .green
        case .Lap: return .yellow
        case .Reset: return .orange
        case .Store: return .orange
        case .REC: return .red
        }
    }

    var color: Color { color(forState: state) }
    
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
        .overlay(Circle()
            .fill(isActive ? Color.clear : Color.gray)
            .opacity(0.4)
        )
            .frame(maxWidth: 75, maxHeight: 75)
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        ButtonTests()
    }
}
