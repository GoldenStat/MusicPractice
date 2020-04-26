//
//  MusicScale.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

struct Scale {
    var scale : MusicScale
    var notes : Set<Notes>
    
    static let C7 = Scale(scale: .C7, notes: Set([.c, .e, .g, .h]))
    
}

/// the scales we can choose to practice
enum MusicScale : String, CaseIterable {
    case C7, Cis7, D7, Eb7, E7, F7
}

enum Notes: String, CaseIterable {
    case c, d, e, f, g, a, h
}

enum SharpNotes: String, CaseIterable {
    typealias RawValue = String
    
    case cis, dis, eis = "e-is", fis, gis, ais
}

enum FlatNotes: String, CaseIterable {
    case ces, des, es, ges, aes = "as", hes = "b"
}
