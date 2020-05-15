//
//  MusicPlayer.swift
//  MusicPractice
//
//  Created by Alexander Völz on 14.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import AudioToolbox


// Adding notes
struct MidiMusicPlayer {

    func playMidiScale(from: UInt8, to: UInt8, noteDuration: Float = 1.0) {
        
        /// minNote, maxNote: first and last midiIndexNotes - see Midi reference in assets
        let minNote = UInt8(21) // A0 // 60: C4
        let maxNote = UInt8(108) // C8 // 72: C5
        guard from < to, from >= minNote, to <= maxNote else { return }
        
        var sequence : MusicSequence? = nil
        var _ = NewMusicSequence(&sequence)
        var track : MusicTrack? = nil
        var _ = MusicSequenceNewTrack(sequence!, &track)
        var time = MusicTimeStamp(1.0)
        
        for midiNoteIndex:UInt8 in from ... to {
            var note = MIDINoteMessage(channel: 0,
                                       note: midiNoteIndex,
                                       velocity: 64,
                                       releaseVelocity: 0,
                                       duration: noteDuration )
            _ = MusicTrackNewMIDINoteEvent(track!, time, &note)
            time += 1
        }
            // Creating a player
            
            var musicPlayer : MusicPlayer? = nil
            var _ = NewMusicPlayer(&musicPlayer)
            
            _ = MusicPlayerSetSequence(musicPlayer!, sequence)
            _ = MusicPlayerStart(musicPlayer!)
    }
        
}
