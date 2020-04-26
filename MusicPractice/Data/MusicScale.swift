//
//  MusicScale.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

struct Scale : Hashable {

    typealias id = MusicScale

    var scale : MusicScale
    var notes : [Notes]
    
    static func notes(scale: MusicScale) -> [ Notes ] {
        switch scale {
        case .C7:
            return [.c, .e, .g, .h]
        case .Cis7:
            return [.cis, .eis, .gis, .c]
        case .D7:
            return [.d, .fis, .a, .c]
        case .Eb7:
            return [.es, .ges, .h, .d]
        case .E7:
            return [.e, .gis, .h, .dis]
        case .F7:
            return [.f, .a, .cis, .e]
        default:
            return []
        }
    }

    static let C7 = Scale(scale: .C7, notes: [.c, .e, .g, .h])
    static let Cis7 = Scale(scale: .Cis7, notes: [.cis, .eis, .gis, .c])
    static let D7 = Scale(scale: .D7, notes: [.d, .fis, .a, .c])
    static let Eb7 = Scale(scale: .Eb7, notes: [.es, .ges, .h, .d])
    static let E7 = Scale(scale: .E7, notes: [.e, .gis, .h, .dis])
    static let F7 = Scale(scale: .F7, notes: [.f, .a, .cis, .e])

//    static let Practice : [ Scale ] = [ .C7, .Cis7, .D7, .Eb7, .E7, .F7 ]
    
    enum FlatScales: String, CaseIterable { case F, B, Es, As, Des, Ges } // as array?
    enum Flats: String, CaseIterable { case b, es, aes, des, ges }

    enum SharpScales: String, CaseIterable { case G, D, A, E, H, Fis }
    enum Sharps: String, CaseIterable { case fis, cis, gis, dis, ais, eis }
}

/// the scales we can choose to practice
enum MusicScale : String, CaseIterable {
    
    // Dominantseptakkorde
    case C7, Cis7, D7, Eb7, E7, F7
    
    // Quintenzirkel
//    case F, B, Es, As, Des, Ges // flat scales
//    case G, D, A, E, H, Fis // sharp scales
}

enum Notes: String, CaseIterable {
    case c, d, e, f, g, a, h
    case cis, dis, eis = "e-is", fis, gis, ais
    case ces, des, es, ges, aes = "as", hes = "b"
}

