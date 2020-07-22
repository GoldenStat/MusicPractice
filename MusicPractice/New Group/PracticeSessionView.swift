//
//  PracticeSessionView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PracticeSessionView: View {
    @State var sessions: [PracticeSessionRecord] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sessions, id: \.self.date) { session in
                    NavigationLink(destination: SessionDetailView(session: session)) {
                    Text(session.date.toString(dateFormat: "YYYY-mm-dd HH:MM:ss"))
                    }
                }
                .onDelete { deleteSession(at: $0) }
            }
            .navigationBarItems(
                trailing: HStack {
                    EditButton()
                    addSessionButton
                })
            .navigationBarTitle("Practice Sessions")
            .animation(.default)
        }
    }
    
    var addSessionButton: some View {
        Image(systemName: "plus.circle.fill")
            .onTapGesture {
                addNewRandomSession()
            }
        
    }
    
    func addNewRandomSession() {
        sessions.append(PracticeSessionRecord())
    }
    
    func deleteSession(at indexSet: IndexSet) {
        sessions.remove(atOffsets: indexSet)
    }
}

struct PracticeSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeSessionView()
    }
}
