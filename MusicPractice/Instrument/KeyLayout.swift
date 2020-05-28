//
//  KeyLayout.swift
//  MusicPractice
//
//  Created by Alexander Völz on 28.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI

protocol KeyLayout {
    var imageName: String { get }
    var image: Image { get }
    var pictureSize : CGSize { get }
    
    /// the key positions in the above picture from lower left to upper right,
    /// each arrayList is a row
    var markerPosition : [[KeyPosition]] { get }
    
    /// the covers for the buttons are a little offset from the markers, as they cover the whole keys
    var coverPosition : [[KeyPosition]] { get }
    
    /// the key Sequence is needed because the buttons are not indexed from bottom left to upper right
    /// but in a certain pattern, maps to marker-/coverPosition
    var keySequence: [[MarkerIndex]] { get }
    
    /// I chose a notes Dictionary to attribute an index to every note in order to find the key
    /// there will need to be a function to attribute a note to every key
    var notes: [ NoteIndex ] { get }
        
}

extension KeyLayout {
    var image: Image { Image(imageName) }
    
    func flatten(_ sequence: [[KeyPosition]]) -> [KeyPosition] {
        var flatList : [KeyPosition] = []
        for line in sequence {
            flatList.append(contentsOf: line)
        }
        return flatList
    }
    
    /// - Parameters:
    ///   - row: the graphical row
    ///   - column: the graphical column
    /// - Returns: the  CGPoint for the key, derived from the markerPosition array, relative to the picture
    func markerPosition(index: MarkerIndex) -> CGPoint? {
        guard isValidMarkerIndex(index: index) else { return nil }
        
        let position = keySequence[index.row-1][index.column-1]
        let coordinate = markerPosition[position.row-1][position.column-1]
        return CGPoint(x: coordinate.x, y: coordinate.y)
    }
    
    func markerPosition(index: BandoneonKeyIndex) -> CGPoint? {
        guard isValidKeyIndex(index: index) else { return nil }
        
        let position = keySequence[index.row-1][index.column-1]
        let coordinate = markerPosition[position.row-1][position.column-1]
        return CGPoint(x: coordinate.x, y: coordinate.y)
    }
    
    func isValidKey(index: KeyIndex, forSequence sequence: [[Any]]) -> Bool {
        sequence.isValid(index: index.row - 1) &&
            sequence.isValid(index: index.column - 1)
    }
    
    /// - Returns: whether the graphical row / column are a valid key position for this KeyLayout
    /// i.e. if the index for the marker exists
    func isValidKeyIndex(index: BandoneonKeyIndex) -> Bool {
        isValidKey(index: index, forSequence: keySequence)
    }
    
    
    /// - Parameters:
    ///   - index: the position of the key
    /// - Returns: whether the graphical row / column are a valid key position for this KeyLayout
    /// i.e. if the index for the marker exists
    func isValidMarkerIndex(index: MarkerIndex) -> Bool {
        isValidKey(index: index, forSequence: markerPosition)
    }
    
    /// Description TODO: not sure what this does, yet. What is KeyNumber supposed to be? Makes only sense in order, or something
    ///  which means the keyboard needs an order
    ///   but this could also be implicit by the notes.map being ordered
    /// - Parameters:
    ///   - index: Bandoneon Index for the selected key
    /// - Returns: returns the Index of the key in a diatonic scale?
    func keyNumber(index: BandoneonKeyIndex) -> Int? {
        guard isValidKeyIndex(index: index) else { return nil }
        fatalError("implement Function")
    }
    
    /// return all indexes that match note and octave
    /// filter all corresponding indexes if `octaves` is empty or `notes` is empty
    func orderedIndexSet(for notes: [Note], inOctaves octaves: [Octave]) -> [NoteIndex] {
        let allOctavesInLayout = self.octaves
        let matchOctaves = (octaves.isEmpty ? allOctavesInLayout : octaves)
        let matchNotes = (notes.isEmpty ? Note.allCases : notes)
        
        let indexSet = self.notes.filter { noteIndex in
            matchOctaves.contains(noteIndex.octave!) && matchNotes.contains(noteIndex.note)
        }
        
        return indexSet
    }
    
    func orderedIndexSet(for notes: [Note], inOctaves octaves: [Octave]) -> [BandoneonKeyIndex] {
        
        // extract keypositions
        return orderedIndexSet(for: notes, inOctaves: octaves).map {$0.index}
    }
    
    /// the octaves this layout comprises
    var octaves: [Octave] {
        Array(Set(notes.compactMap {$0.octave})).sorted()
    }
    
}
