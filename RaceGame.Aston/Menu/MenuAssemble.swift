//
//  MenuAssemble.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 06.03.2024.
//

import UIKit

final class MenuAssemble {
    
    func assemble(storageService: StorageService) -> UIViewController {
        let viewController = MenuView()
        let presenter = MenuPresenter(storageService: storageService, view: viewController)
        viewController.presenter = presenter
        return viewController
    }
}
