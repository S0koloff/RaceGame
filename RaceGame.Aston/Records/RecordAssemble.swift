//
//  RecordAssemble.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 12.03.2024.
//

import UIKit

final class RecordAssemble {
    func assemble(storageService: StorageService) -> UIViewController {
        let viewController = RecordsView()
        let presenter = RecordsPresenter(storageService: storageService)
        viewController.presenter = presenter
        return viewController
    }
}
