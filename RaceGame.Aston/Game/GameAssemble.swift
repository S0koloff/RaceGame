//
//  GameAssemble.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 01.03.2024.
//

import UIKit

final class GameAssemble {
    
    func assemble(storageService: StorageService) -> UIViewController {
        let viewController = GameViewController()
        let presenter = GamePresenter(view: viewController,
                                      tapView: CustomTapView(),
                                      storageService: storageService)
        viewController.presenter = presenter
        return viewController
    }
}
