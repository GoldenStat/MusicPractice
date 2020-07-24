//
//  BandoneonColors.swift
//  MusicPractice
//
//  Created by Alexander Völz on 01.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    //    static let inactive = Color(red: 0, green: 0, blue: 0, opacity: 0.4)
    static let inactive = Color.secondary
    static let marked = Color(red: 255 / 255, green: 228 / 255, blue: 109 / 255, opacity: 0.8)
    
    static func bandoneonKeyColor(for octave: Octave) -> Color {
        switch octave {
        case .subcontra, .contra, .four, .five:
            return Self.inactive
        case .big:
            return Color(red: 100/255, green: 140 / 255, blue: 110 / 266, opacity: 0.9)
        case .small:
            return Color(red: 140/255, green: 140 / 255, blue: 110 / 266, opacity: 0.9)
        case .one:
            return Color(red: 180/255, green: 140 / 255, blue: 100 / 266, opacity: 0.6)
        case .two:
            return Color(red: 200/255, green: 140 / 255, blue: 50 / 266, opacity: 0.6)
        case .three:
            return Color(red: 220/255, green: 140 / 255, blue: 100 / 266, opacity: 0.6)
        }
        
    }
}
