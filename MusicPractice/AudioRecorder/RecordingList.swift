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
    var scale: Scale
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(recorder.recordings(for: nil), id: \.created) {
                    track in
                    RecordingRow(track: track)
                }
                .onDelete(perform: delete)
            }
        }
    }
    
    func deleteAllRecordings() {
        recorder.deleteRecordings(urlsToDelete: recorder.recordings.map {$0.fileURL})
    }

    func moveRecordingsTo(scale: Scale) {
        recorder.fetchRecordings()
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
    
    var track: Recording
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
            HStack {
                Text(track.scaleName)
                Text(track.day)
                Text(track.time)
            }
            .font(.headline)

            Spacer()
            Button(action: {
                self.audioPlayer.togglePlayback(audio: self.track.fileURL)
            }) {
                Image(systemName: symbol[startPauseButtonState]!)
            }
        }
    }
}

struct RecordingList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingList(recorder: AudioRecorder(), scale: .C7)
    }
}
