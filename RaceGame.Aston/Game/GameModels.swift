//
//  Model.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 13.02.2024.
//

import UIKit

enum Direction {
    case left
    case right
}

struct DividerStrips {
    var strips: [UIView]
    
    init() {
        self.strips = []
    }
}

struct Barriers {
    var barriers: [UIView]
    
    init() {
        self.barriers = []
    }
}

struct Cars {
    var cars: [UIView]
    
    init() {
        self.cars = []
    }
}
