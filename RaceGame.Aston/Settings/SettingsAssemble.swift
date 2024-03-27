//
//  SettingsAssemble.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 01.03.2024.
//

import UIKit

final class SettingsAssemble {
    
    func assemble(storageService: StorageService, colorManager: CarColorManager) -> UIViewController {
        let viewController = SettingsView()
        let presenter = SettingsPresenter(storageService: storageService,
                                          colorManager: colorManager)
        viewController.presenter = presenter
        return viewController
    }
}
