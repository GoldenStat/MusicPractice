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
    
    var audioRecorder: AVAudioRecorder!
    
    /// an array that containts the URLs and creation Dates  for  all the acutal recordings retrieved from  the filesystem.
    ///
    /// *gets repopulated by fetchRecordings*
    var recordings = [Recording]()
    
    @Published var isRecording: Bool = false
    @Published var soundSamples: [Float]

    var timer : Timer?
    
    /// - Parameter scale: only returns the recordings that match this scale, or all if nil
    /// - Returns: a list of Recordings that match a scale, or all, if Scale is *nil*
    func recordings(for scale: Scale? = nil) -> [Recording] {
        if let scale = scale {
            return recordings.filter { $0.fileURL.lastPathComponent.starts(with: scale.dominant.rawValue) }
        } else {
            return recordings
        }
    }
    
    override init() {
        soundSamples = [Float]()
        super.init()
        fetchRecordings()
    }
    
    func toggleRecording() {
        isRecording ? stop() : start()
    }
    
    
    /// invalidate the timer and stop the audio Recoder
    func stop() {
        timer?.invalidate()
        audioRecorder.stop()
        isRecording = false
        fetchRecordings()
    }
    
    func pause() {
        timer?.invalidate()
        audioRecorder.pause()
        isRecording = false
    }
    
    func resume() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {_ in
            self.updateSoundMeters()
        }
        
        isRecording = true
        audioRecorder.record()
    }
    
    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
    /// generate a temporary filepath for new recordings
    func generateTemporaryFilePath() -> URL {
        documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
    }

    /// - gets set when a recording starts and is used to
    /// - gets invalidated when a recording is moved
    var audioURL: URL?
    
    /// start a recording session
    /// - starts the timer for sound meter animation
    /// - sets a temporary path for the recording
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
            audioURL = audioURL ?? generateTemporaryFilePath()
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
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
        
    /// renames the current generic recording to a scale-specific one
    func addRecording(to scale: Scale?) {
        let tmpFile = audioURL!.lastPathComponent
        let fileName = "\(scale?.dominant.rawValue ?? "")_\(tmpFile)"

        let from = documentPath.appendingPathComponent(tmpFile)
        let to = documentPath.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.moveItem(at: from, to: to)
            audioURL = nil
        } catch {
            print("Failed to add recording to scale \(scale?.dominant.rawValue ?? "N/A")")
        }
        fetchRecordings()
    }
    
    /// repopulates the recordings-array.
    /// needs to be called every time the recordings are changed
    func fetchRecordings() {
        recordings.removeAll()
        
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil)
        
        for url in directoryContents {
            let recording = Recording(fileURL: url, created: FileManager.getCreationDate(for: url))
            recordings.append(recording)
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
        
    /// remember all the sound samples for this recording, can become quite long
    func updateSoundMeters() {
        audioRecorder.updateMeters()
        soundSamples.append(audioRecorder.averagePower(forChannel: 0))
    }
    
}
