//
//  StorageService.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 06.03.2024.
//

import UIKit

private extension String {
    static let player = "player"
    static let imagePlayerName = "imagePlayerName"
    static let players = "players"
}

final class StorageService {
    
    static let shared = StorageService()
    private init() {}
    
    func savePlayer(_ player: Player) {
        let data = try? JSONEncoder().encode(player)
        UserDefaults.standard.set(data, forKey: .player)
    }
    
    func loadPlayer() -> Player? {
        guard let data = UserDefaults.standard.value(forKey: .player) as? Data else {
            return nil
        }
        
        let player = try? JSONDecoder().decode(Player.self, from: data)
        return player
    }
    
    func saveImage(_ image: UIImage, _ player: Player) throws -> String?{
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let name = player.name
        let url = directory.appendingPathComponent(name)
        
        try data.write(to: url)
        return name
    }
    
    func loadImage(by name: String) -> UIImage? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let url = directory.appendingPathComponent(name)
        return UIImage(contentsOfFile: url.path)
    }
    
    func saveImageName(by name: String) {
        UserDefaults.standard.set(name, forKey: .imagePlayerName)
    }
    
    func saveRecords(_ player: Player, score: Int) {
        var players = getRecords()
        
        if let playerOnList = players.first(where: { $0.name == player.name}) {
            if playerOnList.topScore < score {
                player.topScore = score
                player.topScoreDate = Date().toDateString()
                playerOnList.topScore = player.topScore
            }
        } else {
            player.topScore = score
            player.topScoreDate = Date().toDateString()
            players.append(player)
        }
        let data = try? JSONEncoder().encode(players)
        UserDefaults.standard.set(data, forKey: .players)
    }
    
    func getRecords() -> [Player] {
        guard let data = UserDefaults.standard.data(forKey: .players),
              let players = try? JSONDecoder().decode([Player].self, from: data) else {
            return []
        }
        let sortedPlayers = players.sorted { player1, player2 in
            player1.topScore > player2.topScore
        }
        return sortedPlayers
    }
}
