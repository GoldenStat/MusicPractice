//
//  EnumToggle.swift
//  MusicPractice
//
//  Created by Alexander Völz on 30.05.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

protocol EnumToggle : CaseIterable {
    var string: String { get }
    /// switches the enum Type
    mutating func toggle()
}

enum PlayingDirection : EnumToggle { case open, close
    var string: String { self == .open ? "abriendo" : "cerrando" }
    mutating func toggle() { self = (self == .open ? .close : .open) }
}

enum Hand : EnumToggle { case left, right
    var string: String { self == .left ? "Left Hand" : "Right Hand" }
    mutating func toggle() { self = (self == .left ? .right : .left) }
}
