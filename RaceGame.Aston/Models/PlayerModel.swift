//
//  PlayerModel.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 01.03.2024.
//

import UIKit

final class Player: Codable {
    var name: String
    var avatar: String
    var carColor: CarColors
    var topScore: Int
    var topScoreDate: String
    var threesEnabled: Bool
    var stonesEnabled: Bool
    var gameSpeedX2: Bool
    
    init(name: String,
         avatar: String,
         carColor: CarColors,
         topScore: Int,
         topScoreDate: String,
         threesEnabled: Bool,
         stonesEnabled: Bool,
         gameSpeedX2: Bool ) {
        
        self.name = name
        self.avatar = avatar
        self.carColor = carColor
        self.topScore = topScore
        self.topScoreDate = topScoreDate
        self.threesEnabled = threesEnabled
        self.stonesEnabled = stonesEnabled
        self.gameSpeedX2 = gameSpeedX2
    }
    
    var carUIColor: UIColor {
        switch carColor {
        case .blue:
            return UIColor.blue
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .yellow:
            return UIColor.yellow
        case .purple:
            return UIColor.purple
        case .black:
            return UIColor.black
        }
    }
}
