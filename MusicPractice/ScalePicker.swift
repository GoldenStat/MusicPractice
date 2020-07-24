//
//  ScalePicker.swift
//  MusicPractice
//
//  Created by Alexander Völz on 24.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct MoodPicker: View {
    @Binding var mood: ScaleModifier
    
    var body: some View {
        Picker("modifier", selection: $mood) {
            ForEach(ScaleModifier.allCases, id: \.self) { modifier in
                Text(modifier.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct KeyPicker: View {
    @Binding var key: ScaleKey
    
    var body: some View {
        Picker("currentScale", selection: $key) {
            ForEach(ScaleKey.allCases, id: \.self) { key in
                Text(key.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}
