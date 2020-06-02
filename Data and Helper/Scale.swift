//
//  MusicScale.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI

protocol ScaleProtocol {
    func dominant() -> [Note]
    func diminished() -> [Note]
    func halfDiminished() -> [Note]
}

enum ScaleModifier: String, CaseIterable {
    case dominant,diminished, halfdiminished
    var stringModifier : String {
        switch self {
        case .dominant:
            return "7"
        case .halfdiminished:
            return "m7b5"
        case .diminished:
            return "°"
        }
    }
}

struct ScaleStruct : Hashable {
    let key: ScaleKey
    let notes: [Note]
    let mood: ScaleModifier
    
    var string: String { key.string + mood.stringModifier }
    
    static func string(for key: ScaleKey, _ mood: ScaleModifier) -> String {
        return key.string + mood.stringModifier
    }
    
    init(key: ScaleKey, notes: [Note], mood: ScaleModifier) {
        self.key = key
        self.mood = mood
        self.notes = notes
    }

    /// copies the notes from a previously created ScaleStruct with the same (key,mood)-tuple
    init(key: ScaleKey, mood: ScaleModifier) {
        let notes = Scale.notes(for: key, mood)
        self.key = key
        self.mood = mood
        self.notes = notes
    }
}

struct Scale {

    /// - Returns: first notes array that matches given scale key and mood, empty List, otherwise
    /// - Parameters:
    /// - key: a base key of the music scale
    /// - mood: an applied modifier
    static func notes(for key: ScaleKey, _ mood: ScaleModifier) -> [Note] {
        items.filter { $0.key == key && $0.mood == mood }.first?.notes ?? []
    }
    
    static func scale(for key: ScaleKey, _ mood: ScaleModifier) -> ScaleStruct {
        let notes = Self.notes(for: key, mood)
        return ScaleStruct(key: key, notes: notes, mood: mood)
    }

    static func string(for key: ScaleKey, _ mood: ScaleModifier) -> String {
        ScaleStruct.string(for: key, mood)
    }
    /// accessors to the keys and moods
    static let keys = ScaleKey.allCases
    static let moods = ScaleModifier.allCases
    
    /// some smample Scales
    static var C7: ScaleStruct { ScaleStruct(key: .C, mood: .dominant) }
    static var D7: ScaleStruct { ScaleStruct(key: .D, mood: .dominant) }
    static var G7: ScaleStruct { ScaleStruct(key: .G, mood: .dominant) }
    static var D7dim: ScaleStruct { ScaleStruct(key: .D, mood: .diminished) }
    static var D7b5: ScaleStruct { ScaleStruct(key: .D, mood: .halfdiminished) }

    /// a list of scales for all keys with all modifiers
    /// this struct is being used for all future access to these Scale structs.
    // NOTE: could be a function with a `switch` to assure completeness
    private static let items : [ ScaleStruct ] = [
        ScaleStruct(key: .C, notes: [ .c, .e, .g, .hes ], mood: .dominant),
        ScaleStruct(key: .C, notes: [ .c, .es, .ges, .hes ], mood: .diminished),
        ScaleStruct(key: .C, notes: [ .c, .es, .ges, .a ], mood: .halfdiminished),

        ScaleStruct(key: .Cis, notes: [ .cis, .eis, .gis, .h ], mood: .dominant),
        ScaleStruct(key: .Cis, notes: [ .cis, .e, .g, .h ], mood: .diminished),
        ScaleStruct(key: .Cis, notes: [ .cis, .e, .g, .hes ], mood: .halfdiminished),

        ScaleStruct(key: .D, notes: [ .d, .fis, .a, .c ], mood: .dominant),
        ScaleStruct(key: .D, notes: [ .d, .f, .aes, .c ], mood: .diminished),
        ScaleStruct(key: .D, notes: [ .d, .f, .aes, .h ], mood: .halfdiminished),

        ScaleStruct(key: .Es, notes: [ .es, .g, .hes, .des ], mood: .dominant),
        ScaleStruct(key: .Es, notes: [ .es, .ges, .a, .des ], mood: .diminished),
        ScaleStruct(key: .Es, notes: [ .es, .ges, .a, .c ], mood: .halfdiminished),

        ScaleStruct(key: .E, notes: [ .e, .gis, .h, .d ], mood: .dominant),
        ScaleStruct(key: .E, notes: [ .e, .g, .hes, .d ], mood: .diminished),
        ScaleStruct(key: .E, notes: [ .e, .g, .hes, .cis ], mood: .halfdiminished),
        
        ScaleStruct(key: .F, notes: [ .f, .a, .c, .es ], mood: .dominant),
        ScaleStruct(key: .F, notes: [ .f, .aes, .ces, .es ], mood: .diminished),
        ScaleStruct(key: .F, notes: [ .f, .aes, .ces, .d ], mood: .halfdiminished),
        
        ScaleStruct(key: .Fis, notes: [ .fis, .ais, .cis, .e ], mood: .dominant),
        ScaleStruct(key: .Fis, notes: [ .fis, .a , .c, .e ], mood: .diminished),
        ScaleStruct(key: .Fis, notes: [ .fis, .a , .c, .es ], mood: .halfdiminished),
        
        
        ScaleStruct(key: .G, notes: [ .g, .h, .d, .f ], mood: .dominant),
        ScaleStruct(key: .G, notes: [ .g, .hes, .cis, .f ], mood: .diminished),
        ScaleStruct(key: .G, notes: [ .g, .hes, .cis, .e ], mood: .halfdiminished),
        
        ScaleStruct(key: .As, notes: [ .aes, .c, .es, .ges ], mood: .dominant),
        ScaleStruct(key: .As, notes: [ .aes, .h, .d, .ges ], mood: .halfdiminished),
        ScaleStruct(key: .As, notes: [ .aes, .h, .d, .f ], mood: .halfdiminished),
        
        ScaleStruct(key: .A, notes: [ .a, .cis, .e, .g ], mood: .dominant),
        ScaleStruct(key: .A, notes: [ .a, .c, .es, .g ], mood: .halfdiminished),
        ScaleStruct(key: .A, notes: [ .a, .c, .es, .ges ], mood: .halfdiminished),
        
        ScaleStruct(key: .Bb, notes: [ .hes, .d, .f, .aes ], mood: .dominant),
        ScaleStruct(key: .Bb, notes: [ .hes, .cis, .e, .aes ], mood: .halfdiminished),
        ScaleStruct(key: .Bb, notes: [ .hes, .cis, .e, .g ], mood: .halfdiminished),
        
        ScaleStruct(key: .B, notes: [ .h, .dis, .fis, .a ], mood: .dominant),
        ScaleStruct(key: .B, notes: [ .h, .d, .f, .a ], mood: .halfdiminished),
        ScaleStruct(key: .B, notes: [ .h, .d, .f, .aes ], mood: .halfdiminished)
    ]
}

/// Scale.C.dominant -> [Notes]
// NOTE: might be deleteable or at least simplifiable
enum ScaleKey : String, ScaleProtocol, CaseIterable {

    case C,Cis,D,Es,E,F,Fis,G,As,A,Bb,B

    var string: String { self.rawValue }

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

    static var selectableScales : [ScaleKey] = [.C,.D,.E] // subgroup we want to allow for selection
    
    enum FlatScales: String, CaseIterable { case F, B, Es, As, Des, Ges }
    enum Flats: String, CaseIterable { case b, es, aes, des, ges }
    enum SharpScales: String, CaseIterable { case G, D, A, E, H, Fis }
    enum Sharps: String, CaseIterable { case fis, cis, gis, dis, ais, eis }
}
