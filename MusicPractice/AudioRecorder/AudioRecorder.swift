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
    
    @Published var soundSamples: [Float]

    var timer : Timer?
    
    /// - Parameter scale: only returns the recordings that match this scale, or all if nil
    /// - Returns: a list of Recordings that match a scale, or all, if Scale is *nil*
    func recordings(for scale: ScaleStruct? = nil) -> [Recording] {
        if let scale = scale {
            return recordings.filter { $0.fileURL.lastPathComponent.starts(with: scale.description) }
        } else {
            return recordings
        }
    }
    
    override init() {
        soundSamples = [Float]()
        super.init()
        fetchRecordings()
    }
    
    /// start -> pause -> continue -> pause -> continue -> stop
    /// start -> pause -> stop -> start
    /// start -> stop -> start
    enum State { case stopped, paused, recording }
    @Published var state = State.stopped
    
    /// recorder is in a state that allows recording
    var isRecordReady: Bool { state != .recording }
    var didFinishRecording: Bool { state == .stopped }
        
    func toggleRecording(soft: Bool) {
        switch state {
        case .stopped:
            start()
        case .recording:
            if (soft) {
                pause()
            } else {
                stop()
            }
        case .paused:
            resume()
        }
    }
    
    /// invalidate the timer and stop the audio Recoder
    func stop() {
        timer?.invalidate()
        audioRecorder.stop()
        state = .stopped
    }
    
    
    /// pauses recording
    /// recording can be continued
    func pause() {
        timer?.invalidate()
        audioRecorder.pause()
        state = .paused
    }
    
    func resume() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {_ in
            self.updateSoundMeters()
        }
        
        state = .recording
        audioRecorder.record()
    }
            
    let recordingsDirectory = Bundle.main.bundleURL.appendingPathComponent("Recordings")
    
    func recordingsDirectoryExists() -> Bool {
        return (try? FileManager.default.contentsOfDirectory(at: recordingsDirectory, includingPropertiesForKeys: nil)) != nil
    }
    
    /// generate a temporary filepath for new recordings
    func generateTemporaryFilePath() -> URL {
        if !recordingsDirectoryExists() {
            //try to create the recordings directory
            try? FileManager.default.createDirectory(at: recordingsDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        return recordingsDirectory.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
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

            state = .recording
            soundSamples = []
        } catch {
            print("could not start recording")
        }
    }
        
    /// renames the current generic recording to a scale-specific one
    /// invalidates audioURL of recorder
    /// only executes if an audioURL is defined and recording is stopped
    func moveRecording(to scale: ScaleStruct?) {
        guard state == .stopped else { return }
        guard let audioURL = audioURL else { return }
        let tmpFile = audioURL.lastPathComponent
        let fileName = "\(scale?.description ?? "Any")_\(tmpFile)"

        let from = recordingsDirectory.appendingPathComponent(tmpFile)
        let to = recordingsDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.moveItem(at: from, to: to)
            self.audioURL = nil
        } catch {
            print("Failed to add recording to scale \(scale?.description ?? "N/A")")
        }
        fetchRecordings()
    }
    
    /// repopulates the recordings-array.
    /// needs to be called every time the recordings are changed
    func fetchRecordings() {
        recordings.removeAll()
        
        if let directoryContents = try? FileManager.default.contentsOfDirectory(at: recordingsDirectory, includingPropertiesForKeys: nil) {
            
            for url in directoryContents {
                let recording = Recording(fileURL: url, created: FileManager.getCreationDate(for: url))
                recordings.append(recording)
            }
            
            recordings.sort(by: { $0.created.compare($1.created)  == .orderedAscending } )
        }
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
