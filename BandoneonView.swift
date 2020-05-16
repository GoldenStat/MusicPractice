//
//  PositionTesting.swift
//  MusicPractice
//
//  Created by Alexander Völz on 14.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BandoneonView: View {
    
    let layout : KeyLayout
    
    var picture : Image { layout.image }
    var size : CGSize { layout.pictureSize }
    var samplePoints : [KeyPosition] { layout.flatten(layout.markerPosition) }
    
    func position(for point: (CGFloat,CGFloat), with relativeSize: CGSize? = nil) -> CGPoint {
        let size = relativeSize ?? self.size
        return CGPoint(x: width(for: point.0, to: size),
                       y: height(for: point.1, to: size))
    }
    
    func position(for index: BandoneonKeyIndex) -> CGPoint {
        let position = layout.markerPosition(index: index)!
        return position
    }
    
    var markedNotes: [Notes] = []
    var markedKeys: [BandoneonKeyIndex] = [BandoneonKeyIndex(1, 1)]
    
    var buttonPosition = CGPoint(x: 0, y: 0)
    
    func width(for value: CGFloat, to relativeSize: CGSize? = nil) -> CGFloat {
        return CGFloat(value * (relativeSize?.width ?? self.size.width) / self.size.width)
    }
    
    func height(for value: CGFloat, to relativeSize: CGSize? = nil) -> CGFloat {
        return CGFloat(value * (relativeSize?.height ?? self.size.height) / self.size.height)
    }
    
    let buttonSize = Bandoneon.markerSize
    
    var body: some View {
        ZStack {
            picture
                .resizable()
                .frame(width: size.width, height: size.height)
            ForEach(0 ..< self.markedKeys.count) { index in
                Circle()
                    .fill(Color.marked)
                    .overlay(Text("\(index+1)")
                        .font(.largeTitle))
                    .frame(
                        width: self.buttonSize.width,
                        height: self.buttonSize.height
                )
                    .position(self.position(for: self.markedKeys[index]))
                    .offset(x: self.buttonSize.width/2, y: self.buttonSize.height/2)
            }
            
        }
//        .scaledToFit()
    }
}

struct BandoneonView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            BandoneonView(layout: Bandoneon.RightSideKeys(), markedKeys: Bandoneon.RightSideKeys().indexesFor(notes: Scale.C7.notes, inOctave: .three))
            .rotationEffect(Angle(degrees: 90))
//            BandoneonView(layout: Bandoneon.LeftSideKeys())
        }
//    .scaledToFill()
        .scaleEffect(0.4)
        
    }
}
