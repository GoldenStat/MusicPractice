//
//  MusicScale.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

struct Scale : Hashable {
    static func == (lhs: Scale, rhs: Scale) -> Bool {
        lhs.notes == rhs.notes && lhs.dominant == rhs.dominant
    }
    

    typealias id = DominantScales

    var dominant : DominantScales
    var name: String { dominant.rawValue }
    var notes : [Note] { return Self.notes(dominant: dominant)}

    static var selectableScales = DominantScales.allCases // subgroup we want to allow for selection
    
    static func notes(dominant: DominantScales) -> [ Note ] {
        switch dominant {
        case .C7: return [.c, .e, .g, .hes]
        case .Cis7: return [.cis, .eis, .gis, .h]
        case .D7: return [.d, .fis, .a, .c]
        case .Eb7: return [.es, .g, .hes, .des]
        case .E7: return [.e, .gis, .h, .d]
        case .F7: return [.f, .a, .c, .es]
        case .Fis7: return [.fis, .ais, .cis, .e]
        case .G7: return [.g, .h, .d, .f]
        case .Ab7: return [.aes, .c, .es, .ges]
        case .A7: return [.a, .cis, .e, .g]
        case .Bb7: return [.hes, .d, .f, .aes, .hes]
        case .B7: return [.h, .dis, .fis, .a,]
        }
    }
    

    static let C7 = Scale(dominant: .C7)
    static let Cis7 = Scale(dominant: .Cis7)
    static let D7 = Scale(dominant: .D7)
    static let Eb7 = Scale(dominant: .Eb7)
    static let E7 = Scale(dominant: .E7)
    static let F7 = Scale(dominant: .F7)
    
    enum FlatScales: String, CaseIterable { case F, B, Es, As, Des, Ges }
    enum Flats: String, CaseIterable { case b, es, aes, des, ges }

    enum SharpScales: String, CaseIterable { case G, D, A, E, H, Fis }
    enum Sharps: String, CaseIterable { case fis, cis, gis, dis, ais, eis }
    enum DominantScales: String, CaseIterable {
        case C7, Cis7, D7, Eb7, E7, F7
        case Fis7, G7, Ab7, A7, Bb7, B7
    }
}

enum Note: String, CaseIterable {
    case c, d, e, f, g, a, h
    case cis, dis, eis = "e-is", fis, gis, ais
    case ces, des, es, ges, aes = "as", hes = "b"
}

enum Modfier: String, CaseIterable {
    case sharp, flat
}

enum Octave: String, CaseIterable {
    case subcontra, contra, big, small, one, two, three, four, five
}

enum Hand: String, CaseIterable {
    case left, right
}
