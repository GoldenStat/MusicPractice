//
//  MusicScale.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

extension FileManager {
    
    func craeteDir(for scale: Scale) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent(scale.name)
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
    }
}

struct Scale : Hashable {
    static func == (lhs: Scale, rhs: Scale) -> Bool {
        lhs.notes == rhs.notes && lhs.dominant == rhs.dominant
    }
    

    typealias id = DominantScales

    var dominant : DominantScales
    var name: String { dominant.rawValue }
    var notes : [Notes] { return Self.notes(dominant: dominant)}
    var sessions : PracticeSession = PracticeSession() // recordings, practiceLaps

    static func notes(dominant: DominantScales) -> [ Notes ] {
        switch dominant {
        case .C7: return [.c, .e, .g, .h]
        case .Cis7: return [.cis, .eis, .gis, .c]
        case .D7: return [.d, .fis, .a, .c]
        case .Eb7: return [.es, .ges, .h, .d]
        case .E7: return [.e, .gis, .h, .dis]
        case .F7: return [.f, .a, .cis, .e]
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
}

/// the scales we can choose to practice
enum DominantScales : String, CaseIterable {
    
    // Dominantseptakkorde
    case C7, Cis7, D7, Eb7, E7, F7

    func loadLaps() {
        
    }
    // Quintenzirkel
//    case F, B, Es, As, Des, Ges // flat scales
//    case G, D, A, E, H, Fis // sharp scales
}

enum Notes: String, CaseIterable {
    case c, d, e, f, g, a, h
    case cis, dis, eis = "e-is", fis, gis, ais
    case ces, des, es, ges, aes = "as", hes = "b"
}

