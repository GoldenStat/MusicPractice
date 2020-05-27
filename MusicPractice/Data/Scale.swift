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
    case ces, c, cis = "c♯"
    case des, d, dis = "d♯"
    case es, e, eis
    case f, fis = "f♯"
    case ges, g, gis = "g♯"
    case aes = "as", a, ais = "a♯"
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
        
    func string(for noteIndex: NoteIndex) -> String {
        let note = noteIndex.note
        let noteString = note.rawValue
        
        let modifiedString: String
        switch self {
        case .subcontra:
            modifiedString = ",,\(noteString.uppercased())"
        case .contra:
            modifiedString = ",\(noteString.uppercased())"
        case .big:
            modifiedString = "\(noteString.uppercased())"
        case .small:
            modifiedString = "\(noteString.lowercased())"
        case .one:
            modifiedString = "\(noteString.lowercased())'"
        case .two:
            modifiedString = "\(noteString.lowercased())''"
        case .three:
            modifiedString = "\(noteString.lowercased())'''"
        case .four:
            modifiedString = "\(noteString.lowercased())''''"
        case .five:
            modifiedString = "\(noteString.lowercased())'''''"

        }
        return modifiedString
    }

}
