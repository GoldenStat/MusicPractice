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
    static func createDir(for scale: ScaleStruct) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent(scale.description)
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

extension Array {
    func isValid(index: Int) -> Bool {
        index >= 0 && index < self.count
    }
}
