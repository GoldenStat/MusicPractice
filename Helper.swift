//
//  Helper.swift
//  MusicPractice
//
//  Created by Alexander Völz on 27.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
// a file with the latest extensions

import Foundation
import SwiftUI

extension FileManager {
    // creates a directory for a scale if it doesn't exist
    static func createDir(for scale: Scale) {
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

extension FileManager {
    /// extracts the date when a file was created or the current Date if that fails
    static func getCreationDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
}

extension TimeInterval {
    /// stringify the TimeInterval with hh:mm:ss:ms
    var longString: String {
        let centiseconds = Int(self.truncatingRemainder(dividingBy: 100))
        return String(format:"\(string).%02d",centiseconds)
    }

    /// stringify the TimeInterval with hh:mm:ss
    var string: String {
        let totalSeconds = Int(self) / 100
        let totalMinutes = totalSeconds / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes - hours*60
        let seconds = totalSeconds - totalMinutes*60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension Date
{
    // simplify displaying a date as string in a given format
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}

typealias PictureNames = String
extension PictureNames {
    static var bandoneonKeysLeft = "bandoneon-keys-left"
    static var bwBandoneonKeysLeft = "bw-bandoneon-keys-left"
    static var bandoneonKeysRight = "bandoneon-keys-right"
    static var bwBandoneonKeysRight = "bw-bandoneon-keys-right"
    static var bandoneonKeysBoth = "bandoneon-keys-both"
    static var bandoneon = "Bandoneon"
}

// these keyPositions assume our given pictures with a resolution of 1920 x 981 (right hand) and 1920 x 978 pixels (left hand)
// the buttons can be marked with a circle of 100x100 and covered completely with a circle of 172x172 
// to get the positions, the picture has been imported into a keynote document and a corresponding circle has been placed on all positions
// the coordinate system is upper left to lower right
struct BandoneonDimensions {
    static var leftHandPictureSize = (width: 1920, height: 978)
    static var rightHandPictureSize = (width: 1920, height: 981)
    static var leftHandMarkerSize = 100
    static var leftHandCoverSize = 172
    static var leftHandMarkPositions = [
        [ (77,783), (283, 717), (514, 665), (732, 656), (967, 626), (1193, 639), (1442, 652), (1755, 704) ],
        [ (176, 564), (411, 529), (655, 511), (884, 486), (1098, 464), (1333, 490), (1637, 525) ],
        [ (310, 399), (580, 364), (788, 342), (1024, 325), (1267, 338), (1533, 364) ],
        [ (175, 260), (410, 221), (667, 195), (919, 186), (1155, 179), (1399, 209), (1656, 213) ],
        [ (533, 61), (803, 52), (1046, 44), (1308, 52), (1560, 48) ]
    ]
    static var leftHandCoverPositions = [
        [ (57,727), (263, 687), (494, 635), (712, 616), (930, 600), (1160, 600), (1383, 607), (1690, 660) ], 
        [ (154, 520), (385, 494), (615, 454), (842, 454), (1068, 437), (1290, 454), (1573, 484) ],
        [ (280, 354), (541, 232), (764, 302), (990, 284), (1221, 297), (1482, 328) ],
        [ (150, 241), (380, 197), (646, 171), (890, 149), (1107, 149), (1355, 180), (1607, 180) ],
        [ (506, 40), (771, 27), (1019, 14), (1263, 23), (1507, 19) ]
    ]
    static var rightHandMarkPositionsRow = [
        [ (150, 801), (370, 746), (561, 721), (818, 678), (1050, 672), (1271, 666), (1503, 697), (1735, 721) ],
        [ (84, 591), (290, 586), (524, 547), (733, 513), (968, 495), (1172, 508), (1399, 526), (1643, 565) ],
        [ (210, 426), (545, 391), (659, 360), (868, 343), (1094, 365), (1320, 378), (1534, 391) ],
        [ (328, 282), (519, 234), (754, 217), (994, 217), (1216, 251), (1429, 256) ],
        [ (411, 156), (641, 121), (868, 112), (1129, 130), (1325, 143) ],
        [ (515, 42), (763, 16), (1016, 16), (1216, 12) ]
        ]
    static var rightHandCoverPositions: Array<(Int, Int)> = [
        ]

}

extension Color {
    static let inactive = Color(red: 0, green: 0, blue: 0, opacity: 0.4)
    static let marked = Color(red: 255 / 255, green: 228 / 255, blue: 109 / 255, opacity: 0.8)
}
