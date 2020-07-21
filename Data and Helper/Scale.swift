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
    case dominant, diminished, halfdiminished
    
    var description : String {
        switch self {
        case .dominant:
            return "7"
        case .halfdiminished:
            return "m7♭5"
        case .diminished:
            return "°"
        }
    }
}

struct ScaleStruct : Hashable {
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

struct Scale {

    /// - Returns: first notes array that matches given scale key and mood, empty List, otherwise
    /// - Parameters:
    /// - key: a base key of the music scale
    /// - mood: an applied modifier
    static func notes(for key: ScaleKey, _ mood: ScaleModifier) -> [Note] {
        key.notes(for: mood)
    }
    
    static func scale(for key: ScaleKey, _ mood: ScaleModifier) -> ScaleStruct {
        return ScaleStruct(key: key, mood: mood)
    }

    static func string(for key: ScaleKey, _ mood: ScaleModifier) -> String {
        ScaleStruct(key: key, mood: mood).description
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

}

/// a collection of all Scales
enum ScaleKey : String, ScaleProtocol, CaseIterable {

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
        }
    }
    
    // MARK: one function for each mood - returns all the notes that are part of the 'mood' (scale type)
    
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
