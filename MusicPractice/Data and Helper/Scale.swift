//
//  MusicScale.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI

enum Scale {
    /// some sample Scales
    static let C7 = ScaleStruct(key: .C, mood: .dominant)
    static let D7 = ScaleStruct(key: .D, mood: .dominant)
    static let G7 = ScaleStruct(key: .G, mood: .dominant)
    static let D7dim = ScaleStruct(key: .D, mood: .diminished)
    static let D7b5 = ScaleStruct(key: .D, mood: .halfdiminished)

}

protocol ScaleProtocol {
    func dominant() -> [Note]
    func diminished() -> [Note]
    func halfDiminished() -> [Note]
}

enum ScaleModifier: String, CaseIterable, Codable {
    case dominant, diminished, halfdiminished
//    case major, minor
    
    var description : String {
        switch self {
        case .dominant:
            return "7"
        case .halfdiminished:
            return "m7♭5"
        case .diminished:
            return "°"
//        case .minor:
//            return "m?"
//        case .major:
//            return "?"
        }
    }
}

struct ScaleStruct : Hashable, Codable {
        
    var key: ScaleKey
    var mood: ScaleModifier
    var notes: [Note] { key.notes(for: mood) }
    
    var description: String { key.description + mood.description }
    
    init(key: ScaleKey, notes: [Note], mood: ScaleModifier) {
        self.key = key
        self.mood = mood
    }

    /// copies the notes from a previously created ScaleStruct with the same (key,mood)-tuple
    init(key: ScaleKey, mood: ScaleModifier) {
        self.key = key
        self.mood = mood
    }
    
    /// the assets catalog needs one image for every scale that must be named like it's description
    var image: Image {
        Image(description)
    }
}

/// a collection of all Scales
enum ScaleKey : String, ScaleProtocol, CaseIterable, Codable {

    case C,Cis="C♯",D,Es="E♭",E,F,Fis="F♯",G,As="A♭",A,Bb="B♭",B

    var description: String { self.rawValue }

    func notes(for mood: ScaleModifier) -> [Note] {
        switch mood {
        case .diminished:
            return diminished()
        case .dominant:
            return dominant()
        case .halfdiminished:
            return halfDiminished()
//        case .major:
//            return major()
//        case .minor:
//            return minor()
        }
    }
    
    // MARK: one function for each mood - returns all the notes that are part of the 'mood' (scale type)
    
    func major() -> [ Note ] {
        switch self {
        case .C: return [.c, .e, .g, .h]
        case .Cis: return [.cis, .eis, .gis, .c]
        case .D: return [.d, .fis, .a, .cis]
        case .Es: return [.es, .g, .hes, .d]
        case .E: return [.e, .gis, .h, .dis]
        case .F: return [.f, .a, .c, .e]
        case .Fis: return [.fis, .ais, .cis, .eis]
        case .G: return [.g, .h, .d, .fis]
        case .As: return [.aes, .c, .es, .g]
        case .A: return [.a, .cis, .e, .gis]
        case .Bb: return [.hes, .d, .f, .a]
        case .B: return [.h, .dis, .fis, .ais]
        }
    }
    
    func minor() -> [ Note ] {
        switch self {
        case .C: return [.c, .es, .g, .h]
        case .Cis: return [.cis, .e, .gis, .c]
        case .D: return [.d, .f, .a, .cis]
        case .Es: return [.es, .fis, .hes, .d]
        case .E: return [.e, .g, .h, .dis]
        case .F: return [.f, .gis, .c, .e]
        case .Fis: return [.fis, .a, .cis, .eis]
        case .G: return [.g, .ais, .d, .fis]
        case .As: return [.aes, .h, .es, .g]
        case .A: return [.a, .c, .e, .gis]
        case .Bb: return [.hes, .des, .f, .a]
        case .B: return [.h, .d, .fis, .ais]
        }
    }
    
    func dominant() -> [Note] {
        switch self {
        case .C: return [.c, .e, .g, .hes]
        case .Cis: return [.cis, .eis, .gis, .h]
        case .D: return [.d, .fis, .a, .c]
        case .Es: return [.es, .g, .hes, .des]
        case .E: return [.e, .gis, .h, .d]
        case .F: return [.f, .a, .c, .es]
        case .Fis: return [.fis, .ais, .cis, .e]
        case .G: return [.g, .h, .d, .f]
        case .As: return [.aes, .c, .es, .ges]
        case .A: return [.a, .cis, .e, .g]
        case .Bb: return [.hes, .d, .f, .aes]
        case .B: return [.h, .dis, .fis, .a]
        }
    }
    
    func diminished() -> [Note] {
        switch self {
        case .C: return [ .c, .es, .ges, .hes]
        case .Cis: return [ .cis, .e, .g, .h]
        case .D: return [ .d, .f, .aes, .c]
        case .Es: return [ .es, .ges, .a, .des]
        case .E: return [ .e, .g, .hes, .d]
        case .F: return [ .f, .aes, .ces, .es ]
        case .Fis: return [ .fis, .a, .c, .e ]
        case .G: return [ .g, .hes, .des, .f]
        case .As: return [ .aes, .ces, .d, .ges]
        case .A: return [ .a, .c, .es, .g]
        case .Bb: return [ .hes, .des, .e, .aes]
        case .B: return [ .h, .d, .f, .a]
        }
    }
    
    func halfDiminished() -> [Note] {
        switch self {
        case .C, .Es, .Fis, .A: return [ .c, .es, .ges, .a]
        case .Cis, .E, .G, .Bb: return [ .cis, .e, .g, .hes]
        case .D, .F, .As, .B: return [ .d, .f, .aes, .h ]
        }
    }

    // MARK: - scale and note collections (e.g. pentonic circle)
    enum FlatScales: String, CaseIterable { case F, B, Es, As, Des, Ges }
    enum Flats: String, CaseIterable { case b, es, aes, des, ges }
    
    enum SharpScales: String, CaseIterable { case G, D, A, E, H, Fis }
    enum Sharps: String, CaseIterable { case fis, cis, gis, dis, ais, eis }
}
