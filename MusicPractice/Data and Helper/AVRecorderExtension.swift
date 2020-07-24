//
//  AVRecorderExtension.swift
//  newApp
//
//  Created by Alexander Völz on 20.07.20.
//

import Foundation

extension FileManager {
    
    static let recordingsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Recordings")
    
    static func audioURL(named title: String) -> URL {
        
        // try to create the recordings directory
        try? FileManager.default.createDirectory(at: recordingsDirectory, withIntermediateDirectories: true, attributes: nil)

        // return the requested URL
        // NOTE: doesn't care if file exists, just overwrites!
        return recordingsDirectory.appendingPathComponent(title + ".m4a")
    }
    
    static func audioURLs() -> [ URL ] {
        let urls = try? FileManager.default.contentsOfDirectory(at: recordingsDirectory, includingPropertiesForKeys: nil)
        return urls ?? []
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
