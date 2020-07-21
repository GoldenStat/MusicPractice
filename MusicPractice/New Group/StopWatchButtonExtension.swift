//
//  StopWatchButtonExtension.swift
//  newApp
//
//  Created by Alexander Völz on 20.07.20.
//

import SwiftUI

// MARK: - StopWatch button style

extension Button {
    func stopWatchStyle(color: Color) -> some View {
        self
            .buttonStyle(StopWatchButtonStyle(color: color))
    }
}

extension Color {
    static let noon = Color(red: 220/225, green: 220/225, blue: 220/225)
}

struct StopWatchButtonStyle: ButtonStyle {
        
    var color: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Circle()
            .fill(color)
            .overlay(
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .padding(4)
        )
            .shadow(color: .white, radius: 15, x: -10, y: -10)
            .shadow(radius: 25.0, x: 20, y: 20)
            .overlay(configuration.label
                .foregroundColor(.white)
        )
            .frame(maxWidth: 75, maxHeight: 75)
    }
}
