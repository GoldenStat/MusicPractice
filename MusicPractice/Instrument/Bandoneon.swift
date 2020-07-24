//
//  Bandoneon.swift
//  MusicPractice
//
//  Created by Alexander Völz on 14.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI

typealias PictureNames = String
extension PictureNames {
    static var bandoneonKeysLeft = "bandoneon-keys-left"
    static var bwBandoneonKeysLeft = "bw-bandoneon-keys-left"
    static var bandoneonKeysRight = "bandoneon-keys-right"
    static var bwBandoneonKeysRight = "bw-bandoneon-keys-right"
    static var bandoneonKeysBoth = "bandoneon-keys-both"
    static var bandoneonKeysPositionsLeft = "bandoneon-keys-positions-left"
    static var bandoneonKeysPositionsRight = "bandoneon-keys-positions-right"
    static var bandoneon = "Bandoneon"
}


typealias KeyPosition = CGPoint

protocol KeyIndex {
    var row: Int { get }
    var column: Int { get }
}

/// the position from bandoneon notation: see mapping in KeyLayout().keySequence
struct BandoneonKeyIndex : KeyIndex {
    var row: Int
    var column: Int
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
}

/// the position from graphical point of view, counting from (left, bottom) to (right, top), used for accessing markerPosition / coverPosition in KeyLayout
struct MarkerIndex : KeyIndex {
    let row: Int
    let column: Int
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
}

/// for lack of a better naime: the layout uses this to match a note to a bandoneon Key

struct NoteWithOctave {
    let note: Note
    let octave: Octave?
    var description: String { octave?.description(with: note.rawValue) ?? note.rawValue }
    /// determine the color for a key based on its pitch and if the key had an octave assigned
    var color: Color { octave?.color ?? .inactive }
}

struct NoteIndex: Identifiable {
    // MARK: - find out how to make conform to Indentifiable using BandoneonKeyIndex
    var id = UUID() // each index must be unique, that should be enough to satisfy Identifiable
    let index: BandoneonKeyIndex
    let note: NoteWithOctave
    var color: Color { note.color }
    var description: String { note.description }
}

extension Bandoneon {
    static func layout(_ hand: Hand, _ direction: PlayingDirection) -> KeyLayout {
        switch (hand,direction) {
        case (.left,let direction):
            return Bandoneon.LeftKeyLayout(direction: direction)
        case(.right,let direction):
            return Bandoneon.RightKeyLayout(direction: direction)
        }
    }
}

struct BandoneonLayout {
    static var leftOpening = Bandoneon.layout(.left, .open)
    static var rightOpening = Bandoneon.layout(.right, .open)
    static var leftClosing = Bandoneon.layout(.left, .close)
    static var rightClosing = Bandoneon.layout(.right, .close)
//    //    static var layout : [KeyLayout] = [
////    ]
//    
//    static subscript(index: Int) -> KeyLayout {
//        guard (0 ..< Self.layout.count).contains(index) else { fatalError("BandoneonLayout doesn't have \(index) members")
//        }
//        return Self.layout[index]
//    }
}

struct Bandoneon {
    
    enum MarkAction { case mark, cover }
    
    /// these dimensions are relative to the taken keyboard pictures
    static var markerSize = CGSize(width: 100, height: 100)
    static var coverSize = CGSize(width: 172, height: 172)

}

extension Bandoneon {
    /// the layouts for both sides
    struct LeftKeyLayout : KeyLayout  {
        let direction: PlayingDirection
        
        var notes : [NoteIndex] { direction == .open ? _notesOpening : _notesClosing }
        let _notesOpening: [ NoteIndex ] = [
            NoteIndex(index: BandoneonKeyIndex(8,1), note: NoteWithOctave(note: .c, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(1,1), note: NoteWithOctave(note: .d, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(7,1), note: NoteWithOctave(note: .dis, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(3,4), note: NoteWithOctave(note: .e, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(9,1), note: NoteWithOctave(note: .f, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(8,2), note: NoteWithOctave(note: .fis, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(8,3), note: NoteWithOctave(note: .g, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(5,5), note: NoteWithOctave(note: .gis, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(4,4), note: NoteWithOctave(note: .a, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(6,5), note: NoteWithOctave(note: .ais, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(2,1), note: NoteWithOctave(note: .h, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(7,3), note: NoteWithOctave(note: .c, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(7,5), note: NoteWithOctave(note: .cis, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(3,3), note: NoteWithOctave(note: .d, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(6,4), note: NoteWithOctave(note: .dis, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(2,2), note: NoteWithOctave(note: .e, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(8,5), note: NoteWithOctave(note: .f, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(6,1), note: NoteWithOctave(note: .fis, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(5,4), note: NoteWithOctave(note: .g, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(3,2), note: NoteWithOctave(note: .gis, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(4,3), note: NoteWithOctave(note: .a, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(8,4), note: NoteWithOctave(note: .ais, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(4,2), note: NoteWithOctave(note: .h, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(5,3), note: NoteWithOctave(note: .c, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(7,2), note: NoteWithOctave(note: .cis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(5,2), note: NoteWithOctave(note: .d, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(5,1), note: NoteWithOctave(note: .dis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(6,3), note: NoteWithOctave(note: .e, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(7,4), note: NoteWithOctave(note: .f, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(6,2), note: NoteWithOctave(note: .fis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(3,1), note: NoteWithOctave(note: .g, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(9,2), note: NoteWithOctave(note: .gis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(4,1), note: NoteWithOctave(note: .a, octave: .one)),
        ]
        
        let _notesClosing: [ NoteIndex ] = [
            NoteIndex(index: BandoneonKeyIndex(7,1), note: NoteWithOctave(note: .cis, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(3,4), note: NoteWithOctave(note: .d, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(1,1), note: NoteWithOctave(note: .e, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(8,1), note: NoteWithOctave(note: .f, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(9,1), note: NoteWithOctave(note: .fis, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(3,3), note: NoteWithOctave(note: .g, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(5,5), note: NoteWithOctave(note: .gis, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(2,2), note: NoteWithOctave(note: .a, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(6,5), note: NoteWithOctave(note: .ais, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(8,2), note: NoteWithOctave(note: .h, octave: .big)),
            NoteIndex(index: BandoneonKeyIndex(8,4), note: NoteWithOctave(note: .c, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(7,4), note: NoteWithOctave(note: .cis, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(4,4), note: NoteWithOctave(note: .d, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(7,5), note: NoteWithOctave(note: .dis, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(2,1), note: NoteWithOctave(note: .e, octave: .small)), // also (3,2)
            NoteIndex(index: BandoneonKeyIndex(3,2), note: NoteWithOctave(note: .e, octave: .small)), // also (2,1)
            NoteIndex(index: BandoneonKeyIndex(6,1), note: NoteWithOctave(note: .f, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(8,3), note: NoteWithOctave(note: .fis, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(4,3), note: NoteWithOctave(note: .g, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(7,2), note: NoteWithOctave(note: .gis, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(4,2), note: NoteWithOctave(note: .a, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(5,4), note: NoteWithOctave(note: .ais, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(5,3), note: NoteWithOctave(note: .h, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(6,4), note: NoteWithOctave(note: .c, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(5,2), note: NoteWithOctave(note: .cis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(6,3), note: NoteWithOctave(note: .d, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(8,5), note: NoteWithOctave(note: .dis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(6,2), note: NoteWithOctave(note: .e, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(7,3), note: NoteWithOctave(note: .f, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(3,1), note: NoteWithOctave(note: .fis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(9,2), note: NoteWithOctave(note: .g, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(4,1), note: NoteWithOctave(note: .gis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(5,1), note: NoteWithOctave(note: .h, octave: .one)),
        ]
        
        let imageName = PictureNames.bandoneonKeysPositionsLeft
        var pictureSize = CGSize(width: 1920, height: 978)
        
        /// the key positions in the above picture from lower left to upper right,
        /// each arrayList is a row
        let markerPosition : [[KeyPosition]] = [
            [(77,783), (283, 717), (514, 665), (732, 656), (967, 626), (1193, 639), (1442, 652), (1755, 704)],
            [(176, 564), (411, 529), (655, 511), (884, 486), (1098, 464), (1333, 490), (1637, 525)],
            [(310, 399), (580, 364), (788, 342), (1024, 325), (1267, 338), (1533, 364)],
            [(175, 260), (410, 221), (667, 195), (919, 186), (1155, 179), (1399, 209), (1656, 213)],
            [(533, 61), (803, 52), (1046, 44), (1308, 52), (1560, 48)]
            ].map { $0.map { CGPoint(x: $0.0, y: $0.1) } }
        
        /// the covers for the buttons are a little offset from the markers, as they cover the whole keys
        let coverPosition : [[KeyPosition]] = [
            [ (57,727), (263, 687), (494, 635), (712, 616), (930, 600), (1160, 600), (1383, 607), (1690, 660) ],
            [ (154, 520), (385, 494), (615, 454), (842, 454), (1068, 437), (1290, 454), (1573, 484) ],
            [ (280, 354), (541, 232), (764, 302), (990, 284), (1221, 297), (1482, 328) ],
            [ (150, 241), (380, 197), (646, 171), (890, 149), (1107, 149), (1355, 180), (1607, 180) ],
            [ (506, 40), (771, 27), (1019, 14), (1263, 23), (1507, 19) ]
            ].map { $0.map { CGPoint(x: $0.0, y: $0.1) } }
        
        let keySequence: [ [MarkerIndex] ] = [
            [(1,1)],
            [(1,2), (2,1)],
            [(1,3), (2,2), (3,1), (4,1)],
            [(1,4), (2,3), (3,2), (4,2)],
            [(1,5), (2,4), (3,3), (4,3), (5,1)],
            [(1,6), (2,5), (3,4), (4,4), (5,2)],
            [(1,7), (2,6), (3,5), (4,5), (5,3)],
            [(1,8), (2,7), (3,6), (4,6), (5,4)],
            [(4,7), (5,5)]
            ].map { ($0 as [(Int,Int)]).map{MarkerIndex($0.0,$0.1)} }
        
    }
    
}

extension Bandoneon {
    struct RightKeyLayout : KeyLayout {
        
        let imageName = PictureNames.bandoneonKeysPositionsRight
        let pictureSize = CGSize(width: 1920, height: 981)
        
        let direction: PlayingDirection
        let coverPosition: [[KeyPosition]] = [[]]
        
        let markerPosition: [[KeyPosition]] = [
            [ (150, 801), (370, 746), (561, 721), (818, 678), (1050, 672), (1271, 666), (1503, 697), (1735, 721) ],
            [ (84, 591), (290, 586), (524, 547), (733, 513), (968, 495), (1172, 508), (1399, 526), (1643, 565) ],
            [ (210, 426), (455, 391), (659, 360), (868, 343), (1094, 365), (1320, 378), (1534, 391) ],
            [ (328, 282), (519, 234), (754, 217), (994, 217), (1216, 251), (1429, 256) ],
            [ (411, 156), (641, 121), (868, 112), (1129, 130), (1325, 143) ],
            [ (515, 42), (763, 16), (1016, 16), (1216, 12) ]
            ].map { $0.map { CGPoint(x: $0.0, y: $0.1) } }
        
        let keySequence: [[MarkerIndex]] = [
            [(1,1), (2,1)],
            [(1,2), (2,2), (3,1)],
            [(1,3), (2,3), (3,2), (4,1)],
            [(1,4), (2,4), (3,3), (4,2), (5,1)],
            [(1,5), (2,5), (3,4), (4,3), (5,2), (6,1)],
            [(1,6), (2,6), (3,5), (4,4), (5,3), (6,2)],
            [(1,7), (2,7), (3,6), (4,5), (5,4), (6,3)],
            [(1,8), (2,8), (3,7), (4,6), (5,5), (6,4)],
            ].map { ($0 as [(Int,Int)]).map{MarkerIndex($0.0,$0.1)} }
        
        var notes : [NoteIndex] { direction == .open ? _notesOpening : _notesClosing }
        let _notesClosing: [ NoteIndex ] = [
            NoteIndex(index: BandoneonKeyIndex(1,2), note: NoteWithOctave(note: .a, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(1,1), note: NoteWithOctave(note: .ais, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(2,3), note: NoteWithOctave(note: .h, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(4,5), note: NoteWithOctave(note: .c, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(4,4), note: NoteWithOctave(note: .cis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(3,4), note: NoteWithOctave(note: .d, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(2,1), note: NoteWithOctave(note: .dis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(3,2), note: NoteWithOctave(note: .e, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(2,2), note: NoteWithOctave(note: .f, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(3,3), note: NoteWithOctave(note: .fis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(5,3), note: NoteWithOctave(note: .g, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(5,4), note: NoteWithOctave(note: .gis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(4,2), note: NoteWithOctave(note: .a, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(6,4), note: NoteWithOctave(note: .ais, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(6,3), note: NoteWithOctave(note: .h, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(7,4), note: NoteWithOctave(note: .c, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(5,2), note: NoteWithOctave(note: .cis, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(7,3), note: NoteWithOctave(note: .d, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(8,1), note: NoteWithOctave(note: .dis, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(4,1), note: NoteWithOctave(note: .e, octave: .two)), // also (4,1)
            NoteIndex(index: BandoneonKeyIndex(6,2), note: NoteWithOctave(note: .e, octave: .two )), //also (6,2))
            NoteIndex(index: BandoneonKeyIndex(3,1), note: NoteWithOctave(note: .f, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(4,3), note: NoteWithOctave(note: .fis, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(8,3), note: NoteWithOctave(note: .g, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(5,1), note: NoteWithOctave(note: .gis, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(7,2), note: NoteWithOctave(note: .a, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(6,5), note: NoteWithOctave(note: .ais, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(6,1), note: NoteWithOctave(note: .h, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(7,5), note: NoteWithOctave(note: .c, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(8,2), note: NoteWithOctave(note: .cis, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(8,4), note: NoteWithOctave(note: .d, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(8,5), note: NoteWithOctave(note: .dis, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(7,1), note: NoteWithOctave(note: .e, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(8,6), note: NoteWithOctave(note: .f, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(7,6), note: NoteWithOctave(note: .fis, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(5,5), note: NoteWithOctave(note: .g, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(6,6), note: NoteWithOctave(note: .gis, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(5,6), note: NoteWithOctave(note: .a, octave: .three)),
        ]
        let _notesOpening: [ NoteIndex ] = [
            NoteIndex(index: BandoneonKeyIndex(1,2), note: NoteWithOctave(note: .a, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(1,1), note: NoteWithOctave(note: .ais, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(2,3), note: NoteWithOctave(note: .h, octave: .small)),
            NoteIndex(index: BandoneonKeyIndex(3,4), note: NoteWithOctave(note: .c, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(4,5), note: NoteWithOctave(note: .cis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(4,4), note: NoteWithOctave(note: .d, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(2,1), note: NoteWithOctave(note: .dis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(3,3), note: NoteWithOctave(note: .e, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(2,2), note: NoteWithOctave(note: .f, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(5,3), note: NoteWithOctave(note: .fis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(5,4), note: NoteWithOctave(note: .g, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(4,2), note: NoteWithOctave(note: .gis, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(6,3), note: NoteWithOctave(note: .a, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(3,2), note: NoteWithOctave(note: .ais, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(5,2), note: NoteWithOctave(note: .h, octave: .one)),
            NoteIndex(index: BandoneonKeyIndex(7,3), note: NoteWithOctave(note: .c, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(4,3), note: NoteWithOctave(note: .cis, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(6,2), note: NoteWithOctave(note: .d, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(4,1), note: NoteWithOctave(note: .dis, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(8,3), note: NoteWithOctave(note: .e, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(3,1), note: NoteWithOctave(note: .f, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(5,1), note: NoteWithOctave(note: .fis, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(8,1), note: NoteWithOctave(note: .g, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(7,2), note: NoteWithOctave(note: .gis, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(6,1), note: NoteWithOctave(note: .a, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(6,4), note: NoteWithOctave(note: .ais, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(8,2), note: NoteWithOctave(note: .h, octave: .two)),
            NoteIndex(index: BandoneonKeyIndex(7,4), note: NoteWithOctave(note: .c, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(7,1), note: NoteWithOctave(note: .cis, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(8,4), note: NoteWithOctave(note: .d, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(8,5), note: NoteWithOctave(note: .dis, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(7,5), note: NoteWithOctave(note: .e, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(8,6), note: NoteWithOctave(note: .f, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(6,5), note: NoteWithOctave(note: .fis, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(7,6), note: NoteWithOctave(note: .g, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(6,6), note: NoteWithOctave(note: .gis, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(5,5), note: NoteWithOctave(note: .a, octave: .three)),
            NoteIndex(index: BandoneonKeyIndex(5,6), note: NoteWithOctave(note: .h, octave: .three)),
        ]
    }
}
