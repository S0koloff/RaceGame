//
//  SettingsPresenter.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 01.03.2024.
//

import UIKit

final class SettingsPresenter {
    
    private let storageService: StorageService?
    private let colorManager: CarColorManager?
    
    init(storageService: StorageService, colorManager: CarColorManager) {
        self.storageService = storageService
        self.colorManager = colorManager
    }
    
    func getPlayer() -> Player? {
        return storageService?.loadPlayer()
    }
    
    func updateNickname(_ newNickname: String) {
        guard let player = storageService?.loadPlayer() else { return }
        player.name = newNickname
        storageService?.savePlayer(player)
    }
    
    func updateAvatar(_ image: UIImage) {
        guard let player = storageService?.loadPlayer() else { return }
        guard let imageName = try? storageService?.saveImage(image, player) else { return }
        storageService?.saveImageName(by: imageName)
        player.avatar = imageName
        storageService?.savePlayer(player)
    }
    
    func updateCarColor(_ newColor: CarColors) {
        guard let player = storageService?.loadPlayer() else { return }
        player.carColor = newColor
        storageService?.savePlayer(player)
    }
    
    func updateGameSettingsThree() {
        guard let player = getPlayer() else { return }
        if player.threesEnabled == true {
            player.threesEnabled = false
            storageService?.savePlayer(player)
        } else {
            player.threesEnabled = true
            storageService?.savePlayer(player)
        }
    }
    
    func updateGameSettingsStone() {
        guard let player = getPlayer() else { return }
        if player.stonesEnabled == true {
            player.stonesEnabled = false
            storageService?.savePlayer(player)
        } else {
            player.stonesEnabled = true
            storageService?.savePlayer(player)
        }
    }
    
    func updateGameSettingsSpeed() {
        guard let player = getPlayer() else { return }
        if player.gameSpeedX2 == true {
            player.gameSpeedX2 = false
            storageService?.savePlayer(player)
            
        } else {
            player.gameSpeedX2 = true
            storageService?.savePlayer(player)
        }
    }
    
    func getNewColor() -> CarColors? {
        let nextColor = colorManager?.getNextColor()
        return nextColor
    }
    
    func getAvatar() -> UIImage? {
        guard let player = getPlayer() else { return nil }
        guard let avatar = storageService?.loadImage(by: player.avatar) else { return UIImage(systemName: NewPlayer().avatar) }
        return avatar
    }
}
