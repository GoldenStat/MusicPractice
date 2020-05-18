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

protocol KeyLayout {
    var image: Image { get }
    var pictureSize : CGSize { get }

    /// the key positions in the above picture from lower left to upper right,
    /// each arrayList is a row
    var markerPosition : [[KeyPosition]] { get }

    /// the covers for the buttons are a little offset from the markers, as they cover the whole keys
    var coverPosition : [[KeyPosition]] { get }

    /// the key Sequence is needed because the buttons are not indexed from bottom left to upper right
    /// but in a certain pattern, maps to marker-/coverPosition
    var keySequence: [[MarkerIndex]] { get }

    /// I chose a notes Dictionary to attribute an index to every note in order to find the key
    /// there will need to be a function to attribute a note to every key
    var notes: [ NoteIndex ] { get }

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

extension Array {
    func isValid(index: Int) -> Bool {
        index >= 0 && index < self.count
    }
}

struct OctaveKeyIndex {
    let octave: Octave
    let keyIndexes: [ NoteIndex ]
}

struct NoteIndex {
    let note: Note
    let index: BandoneonKeyIndex
    let octave: Octave?
    var string: String {
        if let octave = octave {
            return octave.string(for: self)
        } else {
            return note.rawValue
        }
    }
}

extension KeyLayout {
    
    func flatten(_ sequence: [[KeyPosition]]) -> [KeyPosition] {
        var flatList : [KeyPosition] = []
        for line in sequence {
            flatList.append(contentsOf: line)
        }
        return flatList
    }
    
    /// - Parameters:
    ///   - row: the graphical row
    ///   - column: the graphical column
    /// - Returns: the  CGPoint for the key, derived from the markerPosition array, relative to the picture
    func markerPosition(index: MarkerIndex) -> CGPoint? {
        guard isValidMarkerIndex(index: index) else { return nil }

        let position = keySequence[index.row-1][index.column-1]
        let coordinate = markerPosition[position.row-1][position.column-1]
        return CGPoint(x: coordinate.x, y: coordinate.y)
    }
    
    func markerPosition(index: BandoneonKeyIndex) -> CGPoint? {
        guard isValidKeyIndex(index: index) else { return nil }

        let position = keySequence[index.row-1][index.column-1]
        let coordinate = markerPosition[position.row-1][position.column-1]
        return CGPoint(x: coordinate.x, y: coordinate.y)
    }

    func isValidKey(index: KeyIndex, forSequence sequence: [[Any]]) -> Bool {
        sequence.isValid(index: index.row - 1) &&
            sequence.isValid(index: index.column - 1)
    }

    /// - Returns: whether the graphical row / column are a valid key position for this KeyLayout
    /// i.e. if the index for the marker exists
    func isValidKeyIndex(index: BandoneonKeyIndex) -> Bool {
        isValidKey(index: index, forSequence: keySequence)
    }

    
    /// - Parameters:
    ///   - index: the position of the key
    /// - Returns: whether the graphical row / column are a valid key position for this KeyLayout
    /// i.e. if the index for the marker exists
    func isValidMarkerIndex(index: MarkerIndex) -> Bool {
        isValidKey(index: index, forSequence: markerPosition)
    }
    
    /// Description TODO: not sure what this does, yet. What is KeyNumber supposed to be? Makes only sense in order, or something
    ///  which means the keyboard needs an order
    ///   but this could also be implicit by the notes.map being ordered
    /// - Parameters:
    ///   - index: Bandoneon Index for the selected key
    /// - Returns: returns the Index of the key in a diatonic scale?
    func keyNumber(index: BandoneonKeyIndex) -> Int? {
        guard isValidKeyIndex(index: index) else { return nil }
        fatalError("implement Function")
    }

    /// return all indexes that match note and octave
    /// filter all corresponding indexes if octave is nil or note is nil
    func indexesFor(note searchedNote: Note?, inOctave oct: Octave?) -> [BandoneonKeyIndex] {
        var indexes = [BandoneonKeyIndex]()
        
        for noteIndex in self.notes {
            if let selectedOctave = oct { // an octave was selected, return only notes from this octave
                if selectedOctave == noteIndex.octave {
                    if let searchedNote = searchedNote { // if note was selected return only this notes value
                        if noteIndex.note == searchedNote {
                            indexes.append(noteIndex.index)
                        }
                    } else {
                        indexes.append(noteIndex.index)
                    }
                }
            } else { // return all octaves from layout that match the note
                for noteIndex in self.notes {
                    if let searchedNote = searchedNote { // if note was selected return only this notes value
                        if noteIndex.note == searchedNote {
                            indexes.append(noteIndex.index)
                        }
                    } else {
                        indexes.append(noteIndex.index)
                    }
                }
            }
        }
        return indexes
    }
    
    func indexesFor(notes: [Note], inOctave oct: Octave?) -> [ BandoneonKeyIndex ] {
        var indexes = [BandoneonKeyIndex]()
        
        _ = notes.map { indexes.append(contentsOf: indexesFor(note: $0, inOctave: oct)) }

        return indexes
    }
}

protocol KeyNotes {
    var direction: Bandoneon.PlayingDirection { get }
    var hand: Bandoneon.Hand { get }
    func notes(row: Int, column: Int) -> Note
}

struct Bandoneon {
 
    enum PlayingDirection { case open, close }
    enum Hand { case left, right }

    enum MarkAction { case mark, cover }
    
    /// these dimensions are relative to the taken keyboard pictures
    static var markerSize = CGSize(width: 100, height: 100)
    static var coverSize = CGSize(width: 172, height: 172)

    ///
    struct LeftSideKeys : KeyLayout {
        var notes: [ NoteIndex ] = []

        let image: Image = Image(.bandoneonKeysPositionsLeft)
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
        
    struct RightSideKeys : KeyLayout {
        
        let image: Image = Image(.bandoneonKeysPositionsRight)
        let pictureSize = CGSize(width: 1920, height: 981)
        
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
        
        let notes: [ NoteIndex ] = [
                NoteIndex(note: .a, index: BandoneonKeyIndex(1,2), octave: .small),
                NoteIndex(note: .ais, index: BandoneonKeyIndex(1,1), octave: .small),
                NoteIndex(note: .h, index: BandoneonKeyIndex(2,3), octave: .small),
                NoteIndex(note: .c, index: BandoneonKeyIndex(3,4), octave: .one),
                NoteIndex(note: .cis, index: BandoneonKeyIndex(4,5), octave: .one),
                NoteIndex(note: .d, index: BandoneonKeyIndex(4,4), octave: .one),
                NoteIndex(note: .dis, index: BandoneonKeyIndex(2,1), octave: .one),
                NoteIndex(note: .e, index: BandoneonKeyIndex(3,3), octave: .one),
                NoteIndex(note: .f, index: BandoneonKeyIndex(2,2), octave: .one),
                NoteIndex(note: .fis, index: BandoneonKeyIndex(5,3), octave: .one),
                NoteIndex(note: .g, index: BandoneonKeyIndex(5,4), octave: .one),
                NoteIndex(note: .gis, index: BandoneonKeyIndex(4,2), octave: .one),
                NoteIndex(note: .a, index: BandoneonKeyIndex(6,3), octave: .one),
                NoteIndex(note: .ais, index: BandoneonKeyIndex(3,2), octave: .one),
                NoteIndex(note: .h, index: BandoneonKeyIndex(5,2), octave: .one),
                NoteIndex(note: .c, index: BandoneonKeyIndex(7,3), octave: .two),
                NoteIndex(note: .cis, index: BandoneonKeyIndex(4,3), octave: .two),
                NoteIndex(note: .d, index: BandoneonKeyIndex(6,2), octave: .two),
                NoteIndex(note: .dis, index: BandoneonKeyIndex(4,1), octave: .two),
                NoteIndex(note: .e, index: BandoneonKeyIndex(8,3), octave: .two),
                NoteIndex(note: .f, index: BandoneonKeyIndex(3,1), octave: .two),
                NoteIndex(note: .fis, index: BandoneonKeyIndex(5,1), octave: .two),
                NoteIndex(note: .g, index: BandoneonKeyIndex(8,1), octave: .two),
                NoteIndex(note: .gis, index: BandoneonKeyIndex(7,2), octave: .two),
                NoteIndex(note: .a, index: BandoneonKeyIndex(6,1), octave: .two),
                NoteIndex(note: .ais, index: BandoneonKeyIndex(6,4), octave: .two),
                NoteIndex(note: .h, index: BandoneonKeyIndex(8,2), octave: .two),
                NoteIndex(note: .c, index: BandoneonKeyIndex(7,4), octave: .three),
                NoteIndex(note: .cis, index: BandoneonKeyIndex(7,1), octave: .three),
                NoteIndex(note: .d, index: BandoneonKeyIndex(8,4), octave: .three),
                NoteIndex(note: .dis, index: BandoneonKeyIndex(8,5), octave: .three),
                NoteIndex(note: .e, index: BandoneonKeyIndex(7,5), octave: .three),
                NoteIndex(note: .f, index: BandoneonKeyIndex(8,6), octave: .three),
                NoteIndex(note: .fis, index: BandoneonKeyIndex(6,5), octave: .three),
                NoteIndex(note: .g, index: BandoneonKeyIndex(7,6), octave: .three),
                NoteIndex(note: .gis, index: BandoneonKeyIndex(6,6), octave: .three),
                NoteIndex(note: .a, index: BandoneonKeyIndex(5,5), octave: .three),
                NoteIndex(note: .h, index: BandoneonKeyIndex(5,6), octave: .three)
            ]
    }

}
