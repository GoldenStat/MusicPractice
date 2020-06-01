//
//  CloudTrack.swift
//  MusicPractice
//
//  Created by Alexander Völz on 27.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import CloudKit

extension String {
    struct CloudRecord {
        static let instance = "Instance"
        static let session = "Session"
        enum Keys : String { case scaleName, comment, recording, recordLength }
    }
}

/// CloudElements facilitate saving to the cloud
/// - Parameter key: the dictionary String for the element to save
/// - Parameter value: the actual value used
/// - Parameter isAssset: set this to true and provide a URL to the asset
struct CloudElement {
    var key: String
    var value: Any
    var isAsset : Bool = false
}

extension CKRecord {
    struct New {
        static let scaleName = "scaleName"
        static let comment = "comment"
        static let length = "recordLength"
        static let recording = "recording"
    }
}


/// save / load recordings to cloud
/// loading to implement
struct CloudTrack {
    
    enum TrackStatus { case new, error, done }
        
    static var status : TrackStatus = .new
    
    struct Keys {
        static let scaleName = "scaleName"
        static let comment = "comment"
        static let length = "recordLength"
        static let recording = "recording"
    }
    
    var comment = ""
    
    /// saves the given practice instance to the private cloud
    /// bail out if no valid recording exists, yet
    func saveToCloud(recordType: String, instance: PracticeInstance) {
        
        
        guard let recordingURL = instance.recordingURL else { return }

        let elementsToSave : [CloudElement] = [CloudElement(key: Keys.scaleName, value:instance.practiceScale.string),
                                               CloudElement(key: Keys.comment, value: comment),
                                               CloudElement(key: Keys.recording, value: recordingURL, isAsset: true),
                                               CloudElement(key: Keys.length, value: instance.practiceTime)
        ]
        
        let instanceRecord = CKRecord(recordType: recordType)
        
        for element in elementsToSave {
            if element.isAsset {
                instanceRecord[element.key] = CKAsset(fileURL: element.value as! URL)
            } else {
                instanceRecord[element.key] = element.value as? CKRecordValue
            }
        }
        
        CKContainer.default().privateCloudDatabase.save(instanceRecord) { instanceRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    Self.status = .error
                } else {
                    print("Done!")
                    Self.status = .done
                }
            }
                
        }
    }
        
    var instances = [PracticeInstance]()
    
    /// for now, only fetch metadata, not the recording
    mutating func fetchInstances() {
        
        var savedInstances = [PracticeInstance]()
        
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: String.CloudRecord.instance, predicate: pred)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = [Keys.comment,
                                 Keys.scaleName,
                                 // String.CloudRecord.Keys.recording.rawValue
        ]
        operation.resultsLimit = 50
                
        operation.recordFetchedBlock = { record in

//            var scaleName = record[Keys.scaleName]
//            var comments = record[Keys.comment]
//            let track = PracticeInstance(date: record.creationDate!, recordingURL: nil, practiceTime: 0, practiceScale: <#T##Scale#>)
//            whistle.genre = record["genre"]
//            whistle.comments = record["comments"]
//            instanceRecord[String.CloudRecord.Keys.scaleName.rawValue] = instance.practiceScale.name as CKRecordValue
//            instanceRecord[String.CloudRecord.Keys.comments.rawValue] = comments as CKRecordValue
//            sessions.addInstance(instance: track)
            savedInstances.append(PracticeInstance(practiceScale: Scale.C7))
        }
        
        
        operation.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    Self.status = .done
//                    self.instances = savedInstances // objectDidChange.send
                } else {
                    print("Fetch failed\nThere was a problem fetching the list of whistles; please try again: \(error!.localizedDescription)")
                }
            }
        }
    }
    
}
