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

class AudioPlayer: ObservableObject {
    let objectWillChange = PassthroughSubject<AudioPlayer,Never>()
    
    var isPlaying = false { didSet { objectWillChange.send(self) } }
    var audioPlayer: AVAudioPlayer!
    
    
}
