//
//  TecladoBandoneonLeftView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 14.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct TecladoBandoneonLeftView: View {
        
    func positionAt(reference: CGSize, row: Int, column: Int) -> CGPoint {
//        let (xPoint, yPoint) = markerPosition[row][column]
//        let newPointX = xPoint * ( reference.width / Bandoneon.LeftSideKeys.pictureSize.width ) / 6
//        let newPointY = yPoint * ( Bandoneon.LeftSideKeys.pictureSize.height / reference.height )

//        return CGPoint(x: xPoint - 624, y: yPoint + 226)
        return CGPoint(x: 0, y: 0)
//        return CGSize(width: 0, height: 0)
    }

    let markerSize = Bandoneon.markerSize
    var markerPosition = Bandoneon.LeftSideKeys().markerPosition
    let pictureSize = Bandoneon.LeftSideKeys().pictureSize

    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("position: \(self.positionAt(reference: geo.size, row: 1, column: 1).debugDescription)")
                
                TecladoView()
                
                .scaledToFit()
            }
        }
    }
}

struct TecladoView: View {
    var body: some View {
//        Bandoneon.LeftSideKeys.image
        Image(PictureNames.bandoneonKeysPositionsLeft)
            .resizable()
            .scaledToFit()
            .overlay(
                Circle()
                    .fill(Color.green)
                    .frame(width: 100, height: 100)
//                    .size(CGSize(width: 100, height: 100))
        )
    }
}

struct TecladoBandoneonLeftView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TecladoView()
                .scaleEffect(0.5)
        }
    }
}
