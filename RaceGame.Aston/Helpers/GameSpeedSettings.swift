//
//  GameSpeedSettings.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 12.03.2024.
//

import Foundation

struct GameSpeedSettingsStruct {
    let timerBarries: Double
    let durationCars: Double
    let durationDividers: Double
    let durationBarriers: Double
}

final class GameSpeedSettings {
    
    func getGameSettings(for speedX2: Bool) -> GameSpeedSettingsStruct {
        if speedX2 == false {
            return GameSpeedSettingsStruct(timerBarries: 2, durationCars: 4, durationDividers: 3, durationBarriers: 3)
        } else {
            return GameSpeedSettingsStruct(timerBarries: 0.5, durationCars: 3, durationDividers: 1.8, durationBarriers: 2)
        }
    }
}
