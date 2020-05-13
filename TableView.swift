//
//  TableView.swift
//  MusicPractice
//
//  Created by Alexander Völz on 03.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct TableColumn<Structure, Type> {
    var title: Type
    var keyPath: KeyPath<Structure, Type>
}

protocol TableRepresentable : Hashable {
    associatedtype ItemType where ItemType: StringProtocol
    static var tableStructure: [ TableColumn<Self,ItemType> ] { get set }
    static var header : [ItemType] { get }
    var row: [ItemType] { get }
    func description(separator: String, headerOnly: Bool) -> String
}

extension TableRepresentable {

    static func addColumn(named title: ItemType, withPath keyPath: KeyPath<Self,ItemType>) {
        tableStructure.append(TableColumn(title: title, keyPath: keyPath))
    }
    
    /// this gets automagically built by the property wrapper
    static var header : [ItemType] { Self.tableStructure.map { $0.title } }
    static var keyPaths : [KeyPath<Self,ItemType>] { Self.tableStructure.map { $0.keyPath } }

    var row : [ItemType] { Self.keyPaths.map { self[keyPath: $0] } }

    func description(separator: String = "\t", headerOnly: Bool = false) -> String {
        if headerOnly {
            return Self.header.joined(separator: separator)
        } else {
            return row.joined(separator: separator)
        }
    }
}

struct TableRows<T> where T: TableRepresentable {
    private var body: [ T ]
    
    var count : Int { body.count }
    
    init(_ rows: T ...) {
        self.body = rows
    }

    mutating func addRow(row: T) {
        self.body.append(row)
    }
    
    var tableHeader : [ T.ItemType ] {
        return T.header
    }
    
    var tableBody : [[ T.ItemType ]] {
        return body.map {$0.row}
    }
    
    var tableMatrix : [ [ T.ItemType ] ] {
        return [ tableHeader ] + tableBody
    }

    func description(separator: String = "\t") {

        if let row = body.first {
            print(row.description(separator: separator, headerOnly: true))
        }
        
        for row in body {
            print(row.description(separator: separator, headerOnly: false))
        }
    }
}

struct StringEntryTable : TableRepresentable {
    typealias ItemType = String
    var name: String
    var age: String
    var score: Int
    var wrappedScore: String { "\(score)" }

    /// this is part of every Table Representable
    internal static var tableStructure : [ TableColumn<Self, ItemType> ] = [
        TableColumn(title: "name", keyPath: \Self.name),
        TableColumn(title: "age", keyPath: \Self.age),
        TableColumn(title: "score", keyPath: \Self.wrappedScore),
        ]
}

//struct IntEntryTable : TableRepresentable {
//
//    var age: Int
//    var score: Int
//
//    /// this is part of every Table Representable
//    internal static var tableStructure : [ TableColumn<Self, Int> ] = [
////        TableColumn(title: "name", keyPath: \Self.name),
//        TableColumn(title: "age", keyPath: \Self.age),
//        TableColumn(title: "score", keyPath: \Self.score),
//        ]
//}

struct TableView: View {
    //
    typealias TableRow = TableRows<StringEntryTable>
    @State var tableEntries = TableRow(
    )
    
    func addRow(name: String, age: String, score: Int) {
        tableEntries.addRow(row: StringEntryTable(name: name, age: age, score: score))
    }

    let entries = [
        StringEntryTable(name: "Paul", age: "24", score: 1004),
        StringEntryTable(name: "Martin", age: "24", score: 83),
        StringEntryTable(name: "Gerd", age: "24", score: 24),
        StringEntryTable(name: "Sara", age: "24", score: 31),
        StringEntryTable(name: "Joseph", age: "24", score: 2348)
    ]
    
    @State var index = 0

    func addEntryWithIndex(index: Int) {
        if index < entries.count {
            let newEntry = entries[index]
            addRow(name: newEntry.name, age: newEntry.age, score: newEntry.score)
            self.index += 1
        }
    }

    var body: some View {
        VStack {
            VStack {
                if tableEntries.count > 0 {
                    TextRowView(row: StringEntryTable.header)
                        .font(.headline)
                }
                Section {
                    ForEach(tableEntries.tableBody, id: \.self) { entry in
                        TextRowView(row: entry )
                    }
                }
            }
            .padding()
            
            Spacer()
            
            Button("addEntry") {
                self.addEntryWithIndex(index: self.index)
            }
        }
    }
}

struct TextRowView: View {
    let row: [String]
    var titleCount : Int { row.count }
    
    var body: some View {
        HStack {
            ForEach ( 0 ..< titleCount ) { index in
                if index > 0 {
                    Spacer()
                }
                Text(self.row[index])
            }
        }
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView()
    }
}

