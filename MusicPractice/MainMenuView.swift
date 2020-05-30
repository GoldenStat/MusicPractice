//
//  MainMenuView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 30.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Menu")
                
                List {
                    NavigationLink("Practice", destination: PracticeScaleView(currentScale: .C7)
                    )
                    NavigationLink("Show Notes", destination: AllBandoneonViews())
                }
            }
            .navigationBarTitle("Bandoneonista")
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
