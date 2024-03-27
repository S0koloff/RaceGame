//
//  RecordsPresenter.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 12.03.2024.
//

import UIKit

final class RecordsPresenter {
    
    private let storageService: StorageService?
    
    init(storageService: StorageService) {
        self.storageService = storageService
    }
    
    func getPlayers() -> [Player]? {
        return storageService?.getRecords()
    }
    
    func getAvatar(player: Player) -> UIImage? {
        guard let avatar = storageService?.loadImage(by: player.avatar) else { return UIImage(systemName: NewPlayer().avatar) }
        return avatar
    }
}
