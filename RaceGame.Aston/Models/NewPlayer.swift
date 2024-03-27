//
//  NewPlayer.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 06.03.2024.
//

import UIKit

private enum NewPlayerConstants {
    static let name = "Новый игрок"
    static let avatar = "person.circle.fill"
    static let carColor = CarColors.blue
    static let topScore = 0
    static let date = Date().toDateString()
    static let threesEnabled = true
    static let stonesEnabled = true
    static let gameSpeedX2 = false
}

struct NewPlayer {
    let name = NewPlayerConstants.name
    let avatar = NewPlayerConstants.avatar
    let carColor = NewPlayerConstants.carColor
    let topScore = NewPlayerConstants.topScore
    let date = NewPlayerConstants.date
    let threesEnabled = NewPlayerConstants.threesEnabled
    let stonesEnabled = NewPlayerConstants.stonesEnabled
    let gameSpeedX2 = NewPlayerConstants.gameSpeedX2
}
