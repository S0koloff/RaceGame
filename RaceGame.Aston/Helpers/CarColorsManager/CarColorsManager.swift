//
//  CarColorsManager.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 07.03.2024.
//

import Foundation

class CarColorManager {
    private var currentColorIndex = 0
    
    func getNextColor() -> CarColors {
        let colors: [CarColors] = [
            .blue,
            .red,
            .green,
            .yellow,
            .purple,
            .black
        ]
        
        let newColor = colors[currentColorIndex]
        currentColorIndex = (currentColorIndex + 1) % colors.count
        return newColor
    }
}
