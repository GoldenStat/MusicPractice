//
//  Notes.swift
//  MusicPractice
//
//  Created by Alexander Völz on 01.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI // only needed for Octave.color... but using it in other files, anyway, so I guess it doesn't matter

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
