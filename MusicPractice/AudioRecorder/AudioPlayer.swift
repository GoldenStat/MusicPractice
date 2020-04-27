//
//  AudioPlayer.swift
//  MusicPractice
//
//  Created by Alexander Völz on 27.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {

    @Published var isPlaying = false
    var audioPlayer: AVAudioPlayer!
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    func startPlayBack(audio: URL?) {
        guard let audio = audio else { return }

        /// activate here to force playback through speaker
        //        let playbackSession = AVAudioSession.sharedInstance()
        //        do { try
        //            playbackSession.overrideOutputAudioPort(.speaker)
        //        } catch {
        //            print("Playback through speaker failed")
        //        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed")
        }
    }
    
    func stopPlayBack() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    func togglePlayback(audio: URL? = nil) {
        isPlaying ?
            stopPlayBack() :
            startPlayBack(audio: audio)
    }
}
