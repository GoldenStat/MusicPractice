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

typealias KeyPosition = (CGFloat, CGFloat)

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
    var notes: [ Octaves : [ Notes : BandoneonKeyIndex ] ] { get }
}

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
        index > 0 && index < self.count
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
        return CGPoint(x: coordinate.0, y: coordinate.1)
    }

    func isValid(index: KeyIndex, forSequence sequence: [[KeyIndex]]) -> Bool {
        keySequence.isValid(index: index.row - 1) &&
            keySequence.isValid(index: index.column - 1)
    }

    /// - Returns: whether the graphical row / column are a valid key position for this KeyLayout
    /// i.e. if the index for the marker exists
    func isValidKeyIndex(index: BandoneonKeyIndex) -> Bool {
        let row = index.row
        let column = index.column
        return row - 1 > 0 && row - 1 <= keySequence.count &&
            column - 1 > 0 && column - 1 <= keySequence[row].count
    }

    
    /// - Parameters:
    ///   - index: the position of the key
    /// - Returns: whether the graphical row / column are a valid key position for this KeyLayout
    /// i.e. if the index for the marker exists
    func isValidMarkerIndex(index: MarkerIndex) -> Bool {
        let row = index.row
        let column = index.column
        
        return row - 1 > 0 && row - 1 <= markerPosition.count &&
            column - 1 > 0 && column - 1 <= markerPosition[row].count
    }
    
    /// - Parameters:
    ///   - row: <#row description#>
    ///   - column: <#column description#>
    /// - Returns: returns the Index of the key in a diatonic scale?
    func keyNumber(index: BandoneonKeyIndex) -> Int? {
        guard isValidKeyIndex(index: index) else { return nil }
        
        return nil
    }

}

protocol KeyNotes {
    var direction: Bandoneon.PlayingDirection { get }
    var hand: Bandoneon.Hand { get }
    func notes(row: Int, column: Int) -> Notes
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
        var notes: [Octaves : [Notes : BandoneonKeyIndex]] = [:]
        

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
        ]
        
        /// the covers for the buttons are a little offset from the markers, as they cover the whole keys
        let coverPosition : [[KeyPosition]] = [
            [ (57,727), (263, 687), (494, 635), (712, 616), (930, 600), (1160, 600), (1383, 607), (1690, 660) ],
            [ (154, 520), (385, 494), (615, 454), (842, 454), (1068, 437), (1290, 454), (1573, 484) ],
            [ (280, 354), (541, 232), (764, 302), (990, 284), (1221, 297), (1482, 328) ],
            [ (150, 241), (380, 197), (646, 171), (890, 149), (1107, 149), (1355, 180), (1607, 180) ],
            [ (506, 40), (771, 27), (1019, 14), (1263, 23), (1507, 19) ]
        ]
        
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
    
    //    func convertToKeyPosition(_ lol: [[(CGFloat,CGFloat)]]) -> [[KeyPosition]] {
    //        return lol.map { ($0 as [(CGFloat,CGFloat)]).map{KeyPosition($0.0,$0.1)} }
    //    }
    
    struct RightSideKeys : KeyLayout {
        
        let image: Image = Image(.bandoneonKeysPositionsRight)
        let pictureSize = CGSize(width: 1920, height: 981)
        
        let coverPosition: [[(KeyPosition)]] = [[]]
        
        let markerPosition: [[(KeyPosition)]] = [
            [ (150, 801), (370, 746), (561, 721), (818, 678), (1050, 672), (1271, 666), (1503, 697), (1735, 721) ],
            [ (84, 591), (290, 586), (524, 547), (733, 513), (968, 495), (1172, 508), (1399, 526), (1643, 565) ],
            [ (210, 426), (455, 391), (659, 360), (868, 343), (1094, 365), (1320, 378), (1534, 391) ],
            [ (328, 282), (519, 234), (754, 217), (994, 217), (1216, 251), (1429, 256) ],
            [ (411, 156), (641, 121), (868, 112), (1129, 130), (1325, 143) ],
            [ (515, 42), (763, 16), (1016, 16), (1216, 12) ]
        ]
        
        
        /// return all indexes that match note and octave
        /// filter all corresponding indexes if octave is nil or note is nil
        func indexesFor(note: Notes?, inOctave oct: Octaves?) -> [BandoneonKeyIndex] {
            var indexes = [BandoneonKeyIndex]()
            
            for octave in self.notes.keys {
                if let selectedOctave = oct {
                    if selectedOctave == octave {
                        if let notesDictionary = self.notes[octave] {
                            for entry in notesDictionary {
                                if let note = note {
                                    if entry.key == note {
                                        indexes.append(entry.value)
                                    }
                                } else {
                                    indexes.append(entry.value)
                                }
                            }
                        }
                    }
                } else {
                    if let notesDictionary = self.notes[octave] {
                        for entry in notesDictionary {
                            if let note = note {
                                if entry.key == note {
                                    indexes.append(entry.value)
                                }
                            } else {
                                indexes.append(entry.value)
                            }
                        }
                    }
                }
            }
            return indexes
        }
        
        let keySequence: [[MarkerIndex]] = [
            [(1,1), (2,1)],
            [(1,2), (2,2), (3,1)],
            [(1,3), (2,3), (3,2), (4,1)],
            [(1,4), (2,4), (3,3), (4,2), (5,1)],
            [(1,5), (2,5), (3,4), (4,3), (5,2), (6,1)],
            [(1,6), (2,6), (3,5), (4,5), (5,3), (6,2)],
            [(1,7), (2,7), (3,6), (4,6), (5,4), (6,3)],
            [(1,8), (2,8), (3,7), (4,7), (5,5), (6,4)],
            ].map { ($0 as [(Int,Int)]).map{MarkerIndex($0.0,$0.1)} }
        
        let notes: [ Octaves : [ Notes : BandoneonKeyIndex ] ] = [
            .small : [
                .a: BandoneonKeyIndex(1,2),
                .ais: BandoneonKeyIndex(1,1),
                .h: BandoneonKeyIndex(2,3),
            ],
            .one: [
                .c: BandoneonKeyIndex(3,4),
                .cis: BandoneonKeyIndex(4,5),
                .d: BandoneonKeyIndex(4,4),
                .dis: BandoneonKeyIndex(2,1),
                .e: BandoneonKeyIndex(3,3),
                .f: BandoneonKeyIndex(2,2),
                .fis: BandoneonKeyIndex(5,3),
                .g: BandoneonKeyIndex(5,4),
                .gis: BandoneonKeyIndex(4,2),
                .a: BandoneonKeyIndex(6,3),
                .ais: BandoneonKeyIndex(3,2),
                .h: BandoneonKeyIndex(5,2),
            ],
            .two: [
                .c: BandoneonKeyIndex(7,3),
                .cis: BandoneonKeyIndex(4,3),
                .d: BandoneonKeyIndex(6,2),
                .dis: BandoneonKeyIndex(4,1),
                .e: BandoneonKeyIndex(8,3),
                .f: BandoneonKeyIndex(3,1),
                .fis: BandoneonKeyIndex(5,1),
                .g: BandoneonKeyIndex(8,1),
                .gis: BandoneonKeyIndex(7,2),
                .a: BandoneonKeyIndex(6,1),
                .ais: BandoneonKeyIndex(6,4),
                .h: BandoneonKeyIndex(8,2),
            ],
            .three: [
                .c: BandoneonKeyIndex(7,5),
                .cis: BandoneonKeyIndex(7,1),
                .d: BandoneonKeyIndex(8,4),
                .dis: BandoneonKeyIndex(8,5),
                .e: BandoneonKeyIndex(7,5),
                .f: BandoneonKeyIndex(8,6),
                .fis: BandoneonKeyIndex(6,5),
                .g: BandoneonKeyIndex(7,6),
                .gis: BandoneonKeyIndex(6,6),
                .a: BandoneonKeyIndex(5,5),
                .h: BandoneonKeyIndex(5,6),
            ]
        ]
    }

}
