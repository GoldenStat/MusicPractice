//
//  SessionDetailView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 22.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct SessionDetailView: View {
    
    @State var session: PracticeSessionRecord

    var body: some View {
        List {
            ForEach(session.practiceRecords) { record in
                NavigationLink(destination: PracticeScaleView(scale: record.scale)) {
                    PracticeSessionListDetail(record: record)
                }
            }
            .onDelete { deleteRecord(at: $0) }
        }
        .navigationBarTitle("Session from \(session.date.toString(dateFormat: "YYYY-MM-DD"))")
        .navigationBarItems(
            trailing: HStack {
                EditButton()
                addRecordButton
            })
        .animation(.default)
    }
    
    var addRecordButton: some View {
        Image(systemName: "plus.circle.fill")
            .onTapGesture {
                addNewRandomRecord()
            }
    }
    
    func addNewRandomRecord() {
        session.practiceRecords.append(TaskRecord.samples.randomElement()!)
    }
    
    func deleteRecord(at indexSet: IndexSet) {
        session.practiceRecords.remove(atOffsets: indexSet)
    }
}


struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetailView(session: PracticeSessionRecord.sample)
    }
}

struct PracticeSessionListDetail: View {
    var record: TaskRecord
    
    var body: some View {
        HStack {
            VStack {
                Text(record.name)
                    .font(.title)
                Text(record.duration.description)
                    .font(.subheadline)
            }
            Text(record.result?.filename ?? "Not recorded")
                .font(.body)
        }
    }
}
