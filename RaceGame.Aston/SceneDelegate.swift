//
//  SceneDelegate.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 13.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScence = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScence)
        
        let storageService = StorageService.shared
        
        if storageService.loadPlayer() == nil {
            let newPlayer = NewPlayer()
            storageService.savePlayer(Player(name: newPlayer.name,
                                             avatar: newPlayer.avatar,
                                             carColor: newPlayer.carColor,
                                             topScore: newPlayer.topScore,
                                             topScoreDate: newPlayer.date,
                                             threesEnabled: true,
                                             stonesEnabled: true,
                                             gameSpeedX2: false))
        }
        
        let navigationController = UINavigationController(rootViewController: MenuAssemble().assemble(storageService: storageService))
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

