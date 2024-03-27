//
//  MenuPresenter.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 06.03.2024.
//

import Foundation


final class MenuPresenter {
    
    private let storageService: StorageService?
    private weak var view: MenuView?
    
    init(storageService: StorageService, view: MenuView) {
        self.storageService = storageService
        self.view = view
    }
    
    func startGame() {
        guard let storageService = storageService else { return }
        let gameAssemble = GameAssemble()
        let vc = gameAssemble.assemble(storageService: storageService)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showSettings() {
        guard let storageService = storageService else { return }
        let settingsAssemble = SettingsAssemble()
        let vc = settingsAssemble.assemble(storageService: storageService, colorManager: CarColorManager())
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showRecords() {
        guard let storageService = storageService else { return }
        let recordAssemble = RecordAssemble()
        let vc = recordAssemble.assemble(storageService: storageService)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
