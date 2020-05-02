//
//  AudioRecorder.swift
//  MusicPractice
//
//  Created by Alexander Völz on 27.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

let numberOfSamples = 20

class AudioRecorder: NSObject, ObservableObject {
    
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var scaleFilter : Scale? = nil
    
    @Published var isRecording: Bool = false

    var timer : Timer?
    @Published var soundSamples: [Float]
    var currentSample: Int
    
    override init() {
        soundSamples = [Float](repeating: .zero, count: numberOfSamples)
        currentSample = 0
        super.init()
        fetchRecordings()
    }
    
    func toggleRecording() {
        isRecording ? stop() : start()
    }
    
    func stop() {
        timer?.invalidate()
        audioRecorder.stop()
        isRecording = false
        fetchRecordings()
    }
    
    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var audioURL : URL {
        return documentPath.appendingPathComponent(tmpFileName)
    }
    
    var tmpFileName : String {
        "\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a"
    }
        
    func start() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to setup audio session")
        }
            
        let settings = [
             AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
             AVSampleRateKey: 12000,
             AVNumberOfChannelsKey: 1,
             AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
         ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            /// initialize timer to record sound meters
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {_ in
                self.updateSoundMeters()
            }
            
            isRecording = true
        } catch {
            print("could not start recording")
        }
    }
        
    func addRecording(to scale: Scale) {
        let scaleName = scale.scale.rawValue
        let fileName = "\(Date().toString(dateFormat: "\(scaleName)_dd-MM-YY_HH:mm:ss")).m4a"

        let from = documentPath.appendingPathComponent(tmpFileName)
        let to = documentPath.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.moveItem(at: from, to: to)
        } catch {
            print("Failed to add recording to scale \(scaleName)")
        }
    }
    
    func fetchRecordings(for scale: Scale? = nil) {
        recordings.removeAll()
        
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil)
        
        for url in directoryContents {
            let recording = Recording(fileURL: url, created: getCreationDate(for: url))
            
            let fileName = url.relativeString
            
            if let scaleName = scale?.scale.rawValue {
                if fileName.starts(with: scaleName) {
                    recordings.append(recording)
                }
            } else {
                recordings.append(recording)
            }
        }
        
        recordings.sort(by: { $0.created.compare($1.created)  == .orderedAscending } )
        objectWillChange.send()
    }
    
    func deleteRecordings(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("failed to delete recording <\(url)>")
            }
        }
        fetchRecordings()
    }
        
    func updateSoundMeters() {
        audioRecorder.updateMeters()
        soundSamples[currentSample] = audioRecorder.averagePower(forChannel: 0)
        currentSample = (currentSample + 1) % numberOfSamples
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
