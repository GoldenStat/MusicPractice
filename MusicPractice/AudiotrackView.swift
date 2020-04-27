//
//  AudiotrackView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 26.04.20.
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
    
    func stop() {
        audioRecorder.stop()
        isRecording = false
        fetchRecordings()
    }
    
    override init() {
        super.init()
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
            audioRecorder.record()
            
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

struct AudiotrackView: View {
    @ObservedObject var recorder: AudioRecorder
    
    enum ButtonState : String {
        case start, stop
    }
    
    var colors : [ButtonState : Color] = [
        .start: .green,
        .stop: .red,
    ]
    
    var startStopButtonState: ButtonState { recorder.isRecording ? .stop : .start }
    
    
    var body: some View {
        VStack {
            RecordingList(recorder: recorder)
            
            Button(startStopButtonState.rawValue.capitalized) {
                self.startStopRecording()
            }
            .buttonStyle(TimerButtonStyle(color: colors[startStopButtonState]!))
        }
    }
    
    func startStopRecording() {
        recorder.isRecording ?
            recorder.stop() :
            recorder.start()
    }
}

struct AudiotrackView_Previews: PreviewProvider {
    static var previews: some View {
        AudiotrackView(recorder: AudioRecorder())
    }
}
