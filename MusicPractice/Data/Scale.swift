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

struct ScaleStruct {
    let key: ScaleKey
    let notes: [Note]
    let mode: ScaleModifier
    
    var string: String { key.string + mode.stringModifier }
    
    static func scaleName(for key: ScaleKey, _ mode: ScaleModifier) -> String {
        return key.string + mode.stringModifier
    }
}

struct Scale {

    /// - Returns: first notes array that matches given scale key and mode, empty List, otherwise
    /// - Parameters:
    /// - key: a base key of the music scale
    /// - mode: an applied modifier
    static func notes(for key: ScaleKey, _ mode: ScaleModifier) -> [Note] {
        items.filter { $0.key == key && $0.mode == mode }.first?.notes ?? []
    }
    
    static func scale(for key: ScaleKey, _ mode: ScaleModifier) -> ScaleStruct {
        let notes = Self.notes(for: key, mode)
        return ScaleStruct(key: key, notes: notes, mode: mode)
    }

    static let keys = ScaleKey.allCases
    
    /// a list of scales for all keys with all modifiers
    // NOTE: could be a function with a `switch` to assure completeness
    private static let items : [ ScaleStruct ] = [
        ScaleStruct(key: .C, notes: [ .c, .e, .g, .hes ], mode: .dominant),
        ScaleStruct(key: .C, notes: [ .c, .es, .ges, .hes ], mode: .diminished),
        ScaleStruct(key: .C, notes: [ .c, .es, .ges, .a ], mode: .halfdiminished),

        ScaleStruct(key: .Cis, notes: [ .cis, .eis, .gis, .h ], mode: .dominant),
        ScaleStruct(key: .Cis, notes: [ .cis, .e, .g, .h ], mode: .diminished),
        ScaleStruct(key: .Cis, notes: [ .cis, .e, .g, .hes ], mode: .halfdiminished),

        ScaleStruct(key: .D, notes: [ .d, .fis, .a, .c ], mode: .dominant),
        ScaleStruct(key: .D, notes: [ .d, .f, .aes, .c ], mode: .diminished),
        ScaleStruct(key: .D, notes: [ .d, .f, .aes, .h ], mode: .halfdiminished),

        ScaleStruct(key: .Es, notes: [ .es, .g, .hes, .des ], mode: .dominant),
        ScaleStruct(key: .Es, notes: [ .es, .ges, .a, .des ], mode: .diminished),
        ScaleStruct(key: .Es, notes: [ .es, .ges, .a, .c ], mode: .halfdiminished),

        ScaleStruct(key: .E, notes: [ .e, .gis, .h, .d ], mode: .dominant),
        ScaleStruct(key: .E, notes: [ .e, .g, .hes, .d ], mode: .diminished),
        ScaleStruct(key: .E, notes: [ .e, .g, .hes, .cis ], mode: .halfdiminished),
        
        ScaleStruct(key: .F, notes: [ .f, .a, .c, .es ], mode: .dominant),
        ScaleStruct(key: .F, notes: [ .f, .aes, .ces, .es ], mode: .diminished),
        ScaleStruct(key: .F, notes: [ .f, .aes, .ces, .d ], mode: .halfdiminished),
        
        ScaleStruct(key: .Fis, notes: [ .fis, .ais, .cis, .e ], mode: .dominant),
        ScaleStruct(key: .Fis, notes: [ .fis, .a , .c, .e ], mode: .diminished),
        ScaleStruct(key: .Fis, notes: [ .fis, .a , .c, .es ], mode: .halfdiminished),
        
        
        ScaleStruct(key: .G, notes: [ .g, .h, .d, .f ], mode: .dominant),
        ScaleStruct(key: .G, notes: [ .g, .hes, .cis, .f ], mode: .diminished),
        ScaleStruct(key: .G, notes: [ .g, .hes, .cis, .e ], mode: .halfdiminished),
        
        ScaleStruct(key: .As, notes: [ .aes, .c, .es, .ges ], mode: .dominant),
        ScaleStruct(key: .As, notes: [ .aes, .h, .d, .ges ], mode: .halfdiminished),
        ScaleStruct(key: .As, notes: [ .aes, .h, .d, .f ], mode: .halfdiminished),
        
        ScaleStruct(key: .A, notes: [ .a, .cis, .e, .g ], mode: .dominant),
        ScaleStruct(key: .A, notes: [ .a, .c, .es, .g ], mode: .halfdiminished),
        ScaleStruct(key: .A, notes: [ .a, .c, .es, .ges ], mode: .halfdiminished),
        
        ScaleStruct(key: .Bb, notes: [ .hes, .d, .f, .aes ], mode: .dominant),
        ScaleStruct(key: .Bb, notes: [ .hes, .cis, .e, .aes ], mode: .halfdiminished),
        ScaleStruct(key: .Bb, notes: [ .hes, .cis, .e, .g ], mode: .halfdiminished),
        
        ScaleStruct(key: .B, notes: [ .h, .dis, .fis, .a ], mode: .dominant),
        ScaleStruct(key: .B, notes: [ .h, .d, .f, .a ], mode: .halfdiminished),
        ScaleStruct(key: .B, notes: [ .h, .d, .f, .aes ], mode: .halfdiminished)
    ]
}

/// Scale.C.dominant -> [Notes]
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

enum Note: String, CaseIterable {
    case ces = "c♭", c, cis = "c♯"
    case des = "d♭", d, dis = "d♯"
    case es = "e♭", e, eis
    case fes = "f♭", f, fis = "f♯"
    case ges = "g♭", g, gis = "g♯"
    case aes = "a♭", a, ais = "a♯"
    case hes = "b", h
}

enum Modifier: String, CaseIterable {
    case sharp, flat
}

extension Note {
    func string(modifiedBy modifier: Modifier) -> String {
        switch modifier {
        case .sharp:
            switch self {
            case .c, .d, .f, .g, .a:
                return "\(self.rawValue)♯"
            case .e:
                return Note.f.rawValue
            case .h:
                return Note.c.rawValue
            default: /// no strings provided for modifying twice
                return ""
            }
        case .flat:
            switch self {
            case .d, .e, .g, .a:
                return "\(self.rawValue)♭"
            case .h:
                return Note.hes.rawValue
            case .c:
                return Note.h.rawValue
            case .f:
                return Note.e.rawValue
            default: /// no strings provided for modifying twice
                return ""
            }
        }
    }
    
}

enum LatinNote: String, CaseIterable {
    case do_, re, mi, fa, sol, la, si
}

enum Octave: String, CaseIterable, Comparable {

    case subcontra, contra, big, small, one, two, three, four, five

    var color: Color { .bandoneonKeyColor(for: self) }

    static func < (lhs: Octave, rhs: Octave) -> Bool {
        var notSmaller : [Octave]
        
        switch lhs {
        case .subcontra:
            notSmaller = [.subcontra]
        case .contra:
            notSmaller = [.subcontra, .contra]
        case .big:
            notSmaller = [.subcontra, .contra, .big]
            case .small:
                notSmaller = [.subcontra, .contra, .big, .small]
            case .one:
                notSmaller = [.subcontra, .contra, .big, .small, .one]
            case .two:
                notSmaller = [.subcontra, .contra, .big, .small, .one, .two]
            case .three:
                notSmaller = [.subcontra, .contra, .big, .small, .one, .two, .three]
            case .four:
                notSmaller = [.subcontra, .contra, .big, .small, .one, .two, .three, .four]
        default:
                return false
        }

        return !notSmaller.contains(rhs)
    }
        
    func string(with string: String) -> String {
        let modifiedString: String
        switch self {
        case .subcontra:
            modifiedString = ",,\(string.uppercased())"
        case .contra:
            modifiedString = ",\(string.uppercased())"
        case .big:
            modifiedString = "\(string.uppercased())"
        case .small:
            modifiedString = "\(string.lowercased())"
        case .one:
            modifiedString = "\(string.lowercased())'"
        case .two:
            modifiedString = "\(string.lowercased())''"
        case .three:
            modifiedString = "\(string.lowercased())'''"
        case .four:
            modifiedString = "\(string.lowercased())''''"
        case .five:
            modifiedString = "\(string.lowercased())'''''"

        }
        return modifiedString
    }

}
