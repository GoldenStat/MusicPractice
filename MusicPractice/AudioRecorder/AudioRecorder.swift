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

class AudioRecorder: NSObject, ObservableObject {
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var isRecording: Bool = false { didSet { objectWillChange.send(self) } }
//    @Published var isRecording: Bool = false

    var timer : Timer?
    @Published var soundSamples = [Float]()
    var numberOfSamples: Int = 10
    var currentSample = 0
    
    override init() {
        super.init()
        fetchRecordings()
        soundSamples = [Float].init(repeating: 0, count: numberOfSamples)
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
    
    func start() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to setup audio session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
    
        let settings = [
             AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
             AVSampleRateKey: 12000,
             AVNumberOfChannelsKey: 1,
             AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
         ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            /// initialize timer to record sound meters
//            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {_ in
//                self.updateSoundMeters()
//            }
            
            isRecording = true
        } catch {
            print("could not start recording")
        }
    }
    
    func fetchRecordings() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for url in directoryContents {
            let recording = Recording(fileURL: url, created: getCreationDate(for: url))
            recordings.append(recording)
        }
        
        recordings.sort(by: { $0.created.compare($1.created)  == .orderedAscending } )
        objectWillChange.send(self)
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
    
//    deinit {
//        stop()
//    }
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
