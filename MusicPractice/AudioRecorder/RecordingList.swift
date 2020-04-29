//
//  RecordingList.swift
//  MusicPractice
//
//  Created by Alexander Völz on 26.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct RecordingList: View {
    @ObservedObject var recorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(recorder.recordings, id: \.created) {
                track in
                RecordingRow(audioURL: track.fileURL)
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        
        for index in offsets {
            urlsToDelete.append(recorder.recordings[index].fileURL)
        }
        
        recorder.deleteRecordings(urlsToDelete: urlsToDelete)
    }

}

struct RecordingRow: View {
    
    var audioURL: URL
    @ObservedObject var audioPlayer = AudioPlayer()
  
    enum ButtonState : String {
        case start, stop, pause
    }
    
    var symbol : [ButtonState : String] = [
        .start: "play.circle",
        .stop: "stop.fill",
        .pause: "pause.circle"
    ]
    
    var startPauseButtonState: ButtonState { audioPlayer.isPlaying ? .stop : .start }
    var startStopButtonText: String { "\(startPauseButtonState.rawValue.capitalized) playing audio"
    }

    var body: some View {
        HStack {
            Text("\(audioURL.lastPathComponent)")
            Spacer()
            Button(action: {
                self.audioPlayer.togglePlayback(audio: self.audioURL)
            }) {
                Image(systemName: symbol[startPauseButtonState]!)
            }
        }
    }
}

struct RecordingList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingList(recorder: AudioRecorder())
    }
}
