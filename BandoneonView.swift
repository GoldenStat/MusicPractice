//
//  PositionTesting.swift
//  MusicPractice
//
//  Created by Alexander Völz on 14.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BandoneonView: View {
    
    let keys : KeyPositions
    
    var picture : Image { keys.image }
    var size : CGSize { keys.pictureSize }
    var samplePoints : [KeyPosition] { keys.flatten(keys.markerPosition) }
    
    func position(for point: (CGFloat,CGFloat), with relativeSize: CGSize? = nil) -> CGPoint {
        let size = relativeSize ?? self.size
        return CGPoint(x: width(for: point.0, to: size),
                       y: height(for: point.1, to: size))
    }
    
    var markedNotes: [Notes] = []
    var markedKeys: [BandoneonKeyIndex] = []
    
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
            ForEach(0 ..< self.samplePoints.count) { index in
                Circle()
                    .fill(Color.green)
                    .frame(
                        width: self.buttonSize.width,
                        height: self.buttonSize.height
                )
                    .position(self.position(for: self.samplePoints[index]))
                    .offset(x: self.buttonSize.width/2, y: self.buttonSize.height/2)
            }
            
        }
        .scaledToFit()
    }
}

struct BandoneonView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            BandoneonView(keys: Bandoneon.RightSideKeys())
            BandoneonView(keys: Bandoneon.LeftSideKeys())
        }
        .scaleEffect(0.2)
        
    }
}
