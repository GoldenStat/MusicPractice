//
//  MusicScale.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI

struct Scale : Hashable {
    static func == (lhs: Scale, rhs: Scale) -> Bool {
        lhs.notes == rhs.notes && lhs.dominant == rhs.dominant
    }

    typealias id = DominantScales

    var dominant : DominantScales
    var name: String { dominant.rawValue }
    var notes : [Note] { return Self.notes(dominant: dominant)}

    static var selectableScales = DominantScales.allCases // subgroup we want to allow for selection
    
    static func notes(dominant scale: DominantScales) -> [ Note ] {
        switch scale {
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
    
    static func notes(scale: HalfDiminishedScales) -> [ Note ] {
        switch scale {
        case .Cm7b5: return [ .c, .es, .ges, .hes]
        case .Cism7b5: return [ .cis, .e, .g, .h]
        case .Dm7b5: return [ .d, .f, .aes, .c]
        case .Ebm7b5: return [ .es, .ges, .a, .des]
        case .Em7b5: return [ .e, .g, .hes, .d]
        case .Fm7b5: return [ .f, .aes, .ces, .es ]
        case .Fism7b5: return [ .fis, .a, .c, .e ]
        case .Gm7b5: return [ .g, .hes, .des, .f]
        case .Abm7b5: return [ .aes, .ces, .d, .ges]
        case .Am7b5: return [ .a, .c, .es, .g]
        case .Bbm7b5: return [ .hes, .des, .e, .aes]
        case .Bm7b5: return [ .h, .d, .f, .a]
        }
    }

    static func notes(scale: DiminishedScales) -> [ Note ] {
        switch scale {
        case .Cdim, .Ebdim, .Gesdim, .Adim: return [ .c, .es, .ges, .a]
        case .Cisdim, .Edim, .Gdim, .Bbdim: return [ .cis, .e, .g, .hes]
        case .Ddim, .Fdim, .Abdim, .Bdim: return [ .d, .f, .aes, .h ]
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
    enum HalfDiminishedScales: String, CaseIterable {
        case Cm7b5, Cism7b5, Dm7b5, Ebm7b5, Em7b5, Fm7b5
        case Fism7b5, Gm7b5, Abm7b5, Am7b5, Bbm7b5, Bm7b5
    }
    
    enum DiminishedScales: String, CaseIterable {
        case Cdim, Ebdim, Gesdim, Adim
        case Cisdim, Edim, Gdim, Bbdim
        case Ddim, Fdim, Abdim, Bdim
    }
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
