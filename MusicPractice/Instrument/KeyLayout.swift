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

    var _notesOpening: [NoteIndex] { get }
    var _notesClosing: [NoteIndex] { get }
    var direction: PlayingDirection { get }

}

extension KeyLayout {
    var image: Image { Image(imageName) }
    var pictureRatio: CGFloat { pictureSize.width / pictureSize.height }

    var notes : [NoteIndex] { direction == .open ? _notesOpening : _notesClosing }

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
        let matchOctaves = octaves.isEmpty ? allOctavesInLayout : octaves
        let matchNotes = notes.isEmpty ? Note.allCases : notes
        
        let indexSet = self.notes.filter { matchOctaves.contains($0.note.octave!) && matchNotes.contains($0.note.note) }
        
        return indexSet
    }
    
    func orderedIndexSet(for notes: [Note], inOctaves octaves: [Octave]) -> [BandoneonKeyIndex] {
        // extract keypositions
        return orderedIndexSet(for: notes, inOctaves: octaves).map {$0.index}
    }
    
    /// the octaves this layout comprises
    var octaves: [Octave] {
        Array(Set(notes.compactMap {$0.note.octave})).sorted()
    }
        
    /// get the Position for the index of a key
    func position(forKey key: NoteIndex, with newSize: CGSize) -> CGPoint {
        let newPosition = markerPosition(index: key.index)!
            .mapped(from: pictureSize, to: newSize)

        return newPosition
    }

    /// re-calculate key Positions base on frame Size
    func keyLabels(for notes: [Note], mappedTo newSize: CGSize) -> some View {
        
        let originalSize: CGSize = pictureSize
        let scaleFactor = CGPoint(x: newSize.width / originalSize.width,
                                  y: newSize.height / originalSize.height)
        
        let newButtonSize = CGSize(width: Bandoneon.markerSize.width * scaleFactor.x,
                                   height: Bandoneon.markerSize.height * scaleFactor.y)
        var fontSize : CGFloat { min(newButtonSize.height, newButtonSize.width)/2 }
        
        /// searches for notes in `highlightedNotes`that match `octaves` in layout and
        /// returns their `NoteIndex`es. If `octaves` is empty, `NoteIndex`es for all matching `notes` are returned
        var markedKeys: [NoteIndex] {
            return orderedIndexSet(for: notes, inOctaves: octaves)
        }
        
        /// get the Position for the index of a key
        func position(forKey key: NoteIndex) -> CGPoint {
            let bandoneonIndex = key.index

            let oldPosition = markerPosition(index: bandoneonIndex)!
            let newPosition = CGPoint(x: oldPosition.x * scaleFactor.x, y: oldPosition.y*scaleFactor.y)

            return newPosition
        }

        func highlight(indexKey index: Int) -> some View {
            return Circle()
                .fill(markedKeys[index].note.color)
                .overlay(
                    Text(markedKeys[index].note.string)
                        .font(.system(size: fontSize))
                        .fixedSize(horizontal: true, vertical: false)
            )
                .frame(
                    width: newButtonSize.width,
                    height: newButtonSize.height
            )
                .position(position(forKey: markedKeys[index]))
                .offset(x: newButtonSize.width/2, y: newButtonSize.height/2)
        }
        
        return ForEach(0 ..< markedKeys.count) { index in
            highlight(indexKey: index)
        }
    }
}

extension CGSize {
    func mapped(from originalSize: CGSize, to resultingSize: CGSize) -> CGSize {
        let ratio = CGSize(width: resultingSize.width / originalSize.width,
                           height: resultingSize.height / originalSize.height)

        return CGSize(width: self.width * ratio.width,
                      height: self.height * ratio.height)
    }
}

extension CGPoint {
    func mapped(from originalSize: CGSize, to resultingSize: CGSize) -> CGPoint {
        let ratio = CGPoint(x: resultingSize.width / originalSize.width,
                            y: resultingSize.height / originalSize.height)
        return CGPoint(x: self.x * ratio.x,
                       y: self.y * ratio.y)
    }
}
