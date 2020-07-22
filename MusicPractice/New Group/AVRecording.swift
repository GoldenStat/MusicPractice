//
//  AVRecording.swift
//  newApp
//
//  Created by Alexander Völz on 20.07.20.
//
// thanks to : https://blckbirds.com/post/voice-recorder-app-in-swiftui-2/

import SwiftUI
import AVKit

// MARK: - Recorder Model
class AVRecorder: NSObject, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
        
    static let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    func setup() {
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        // continue
                        print("Recording is allowed on this device")
                    } else {
                        // failed to record! - didn't get permission
                        print("Permission to record audion denied - won't be able to use recorder")
                    }
                }
            }
        } catch {
            // failed to record!
            print("Something went wrong trying to set up a session for recording and playback")
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        success ? print("finished recording") : print("recording was interrupted")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func startRecording(to url: URL) {
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: AVRecorder.settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            
            finishRecording(success: false)
        }
    }
        
}

// MARK: - Player Model
class AVPlayer: NSObject, AVAudioPlayerDelegate, ObservableObject {
    var audioPlayer: AVAudioPlayer!
    @Published var isPlaying = false
    
    
    func setup() {
        
    }
    
    func startPlayback(of audio: URL) {
        // assume audioSession is initialized by audioRecorder?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }
}


// MARK: - ViewModel
class AVRecorderViewModel: ObservableObject {
    @Published var isRecording : Bool = false { didSet { fetchRecordings() } }
    @Published var isPlaying : Bool = false
    
    var recordings: [ResultRecord] = []
    var currentTitle: String?
    
    var recorder = AVRecorder()
    var player = AVPlayer()
    
    // MARK: - control recordings
    func toggleRecording() {
        isRecording ? stopRecording() : startRecording()
    }
    
    func startPlayback(of url: URL) {
        if isRecording {
            stopRecording()
        }
        player.stopPlayback()
        player.startPlayback(of: url)
        isPlaying = true
    }

    func stopPlayback() {
        player.stopPlayback()
        isPlaying = false
    }
    
    init() {
        recorder.setup()
        fetchRecordings()
    }
    
    func fetchRecordings() {
        recordings.removeAll()
        
        for url in FileManager.audioURLs() {
            let date = getCreationDate(for: url)
            let recording = ResultRecord(date: date, url: url, duration: 0)
            recordings.append(recording)
        }
        
//        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
    }
        
    func getCreationDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    func startRecording() {

        guard !isRecording, currentTitle == nil else { return }
        
        // create a title and start the recorder
        let title = Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")
        let audioFilename = FileManager.audioURL(named: title)
        
        recorder.startRecording(to: audioFilename)
        isRecording = true
        
        currentTitle = title // store the title
    }
    
    func stopRecording() {
        // save the recording to the file and add the title to our recordings
        recorder.finishRecording(success: true)
        isRecording = false
        currentTitle = nil
        fetchRecordings()
    }
    
    func deleteRecordings(urls: [URL]) {
        for url in urls {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        fetchRecordings()
    }

}

// MARK: - Controls
struct RecordingButton: View {
    @EnvironmentObject var avRecorder : AVRecorderViewModel
    
    var image : String { avRecorder.isRecording ? "stop.fill" : "circle.fill" }
    var color: Color { avRecorder.isRecording ? .red : .blue }
    
    var body: some View {
        Button() {
            avRecorder.toggleRecording()
        } label: {
            Image(systemName: image)
                .font(.title)
        }
        .stopWatchStyle(color: color)
    }
}

struct PlaybackButton: View {
    @EnvironmentObject var avRecorder : AVRecorderViewModel
    
    var url: URL
    var image : String { avRecorder.isPlaying ? "stop.fill" : "play.fill" }
    var color: Color { avRecorder.isPlaying ? .orange : .green }
    
    var body: some View {
        Button() {
            avRecorder.isPlaying ? avRecorder.stopPlayback() :
                avRecorder.startPlayback(of: url)
        } label: {
            Image(systemName: image)
        }
        .stopWatchStyle(color: color)
    }
}

// MARK: - the views

struct AVRecordingView: View {
    @ObservedObject var avRecorder = AVRecorderViewModel()
    
    var body: some View {
        VStack {
            // list of recordings in Filesystem / iCloud / CoreData?
            List {
                ForEach(avRecorder.recordings, id: \.date) { recording in
                    HStack {
                        Text(recording.url.lastPathComponent)
                        Spacer()
                        PlaybackButton(url: recording.url)
                    }
                }
                .onDelete(perform: delete)
            }
            Spacer()
            // Recording button
            RecordingButton()
        }
        .padding()
        .navigationBarItems(trailing: EditButton())
        .environmentObject(avRecorder)
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(avRecorder.recordings[index].url)
        }
        avRecorder.deleteRecordings(urls: urlsToDelete)
    }
}

struct AVRecording_Previews: PreviewProvider {
    static var previews: some View {
        AVRecordingView()
    }
}
