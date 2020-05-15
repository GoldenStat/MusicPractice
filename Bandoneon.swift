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

protocol KeyPositions {
    var image: Image { get }
    var pictureSize : CGSize { get }

    /// the key positions in the above picture from lower left to upper right,
    /// each arrayList is a row
    var markerPosition : [[KeyPosition]] { get }

    /// the covers for the buttons are a little offset from the markers, as they cover the whole keys
    var coverPosition : [[KeyPosition]] { get }

    /// the key Sequence is needed because the buttons are not indexed from bottom left to upper right
    /// but in a certain pattern
    
    var keySequence: [[(Int, Int)]] { get }

    /// I chose a notes Dictionary to attribute an index to every note in order to find the key
    /// there will need to be a function to attribute a note to every key
    var notes: [ Octaves : [ Notes : (Int, Int) ] ] { get }
}

extension KeyPositions {
    func flatten(_ sequence: [[KeyPosition]]) -> [KeyPosition] {
        var flatList : [KeyPosition] = []
        for line in sequence {
            flatList.append(contentsOf: line)
        }
        return flatList
    }
    
    func keyPosition(row: Int, column: Int) -> CGPoint? {
        guard row - 1 > 0, row - 1 <= keySequence.count else { return nil }
        guard column - 1 > 0, column - 1 <= keySequence[row].count else { return nil }
        
        let (x,y) = keySequence[row-1][column-1]
        let coordinate = markerPosition[x-1][y-1]
        return CGPoint(x: coordinate.0, y: coordinate.1)
    }

    func keyNumber(row: Int, column: Int) -> Int? {
        guard row - 1 > 0, row - 1 <= keySequence.count else { return nil }
        guard column - 1 > 0, column - 1 <= keySequence[row].count else { return nil }

        var flatSequence : [ (Int, Int) ] = []
        let _ = keySequence.map { flatSequence.append(contentsOf: $0) }
        
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
    struct LeftSideKeys : KeyPositions {
        var notes: [Octaves : [Notes : (Int, Int)]]
        

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
        
        let keySequence: [ [(Int, Int)] ] = [
            [(1,1)],
            [(1,2), (2,1)],
            [(1,3), (2,2), (3,1), (4,1)],
            [(1,4), (2,3), (3,2), (4,2)],
            [(1,5), (2,4), (3,3), (4,3), (5,1)],
            [(1,6), (2,5), (3,4), (4,4), (5,2)],
            [(1,7), (2,6), (3,5), (4,5), (5,3)],
            [(1,8), (2,7), (3,6), (4,6), (5,4)],
            [(4,7), (5,5)]
        ]
        
    }


    struct RightSideKeys : KeyPositions {
        
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
        
        let keySequence: [[(Int, Int)]] = [
            [(1,1), (2,1)],
            [(1,2), (2,2), (3,1)],
            [(1,3), (2,3), (3,2), (4,1)],
            [(1,4), (2,4), (3,3), (4,2), (5,1)],
            [(1,5), (2,5), (3,4), (4,3), (5,2), (6,1)],
            [(1,6), (2,6), (3,5), (4,5), (5,3), (6,2)],
            [(1,7), (2,7), (3,6), (4,6), (5,4), (6,3)],
            [(1,8), (2,8), (3,7), (4,7), (5,5), (6,4)],
        ]
        
        let notes: [ Octaves : [ Notes : (Int, Int) ] ] = [
            .big : [
                .a: (1,2),
                .ais: (1,1),
                .h: (2,3),
                ],
            .small: [
                .c: (3,4),
                .cis: (4,5),
                .d: (4,4),
                .dis: (2,1),
                .e: (3,3),
                .f: (2,2),
                .fis: (5,3),
                .g: (5,4),
                .gis: (4,2),
                .a: (6,3),
                .ais: (3,2),
                .h: (5,2),
            ],
            .one: [
                .c: (7,3)
            ]
        ]
    }

}
