//
//  GamePresenter.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 13.02.2024.
//

import UIKit

private extension String {
    static let leftTapImageName = "tap_l"
    static let rightTapImageName = "tap_r"
    static let leftTapText = "Turn left"
    static let rightTapText = "Turn right"
}

final class GamePresenter {
    
    private weak var view: GameViewDelegate?
    private let storageService: StorageService?
    private let gameSpeedSetings = GameSpeedSettings()
    private var tapView: CustomTapView
    private var dividerStrips = DividerStrips()
    private var barriers = Barriers()
    private var cars = Cars()
    private var timerStrips: Timer?
    private var timerBarriers: Timer?
    private var timerCars: Timer?
    private var timerCollisionChecker: Timer?
    private var timerTapInstruction: Timer?
    private var timerPoints: Timer?
    private var moveTimer: Timer?
    var numberOfPoints = 0
    
    init(view: GameViewDelegate, tapView: CustomTapView, storageService: StorageService) {
        self.view = view
        self.tapView = tapView
        self.storageService = storageService
    }
    
    func startNewGame() {
        timerDividerStrip()
        setupTimers()
        
        guard let player = storageService?.loadPlayer() else { return }
        view?.getCarColor(color: player.carUIColor)
    }
    
    // GAME SETTINGS
    func getGameSpeedSettings() -> GameSpeedSettingsStruct {
        guard let player = storageService?.loadPlayer() else { return gameSpeedSetings.getGameSettings(for: false) }
        return gameSpeedSetings.getGameSettings(for: player.gameSpeedX2)
    }
    func setupBarrierThree() -> Bool {
        guard let player = storageService?.loadPlayer() else { return true }
        return player.threesEnabled
    }
    
    func setupBarrierStone() -> Bool {
        guard let player = storageService?.loadPlayer() else { return true }
        return player.stonesEnabled
    }
    
    func addCar(car: UIView) {
        self.cars.cars.append(car)
    }
    
    func cleanCar() {
        
        guard let view = view?.getSuperView() else {
            return
        }
        
        for (index, car) in cars.cars.enumerated() {
            
            guard let carFrame = car.layer.presentation()?.frame else {
                continue
            }
            
            if carFrame.maxY > view.frame.maxY + 100 {
                cars.cars.remove(at: index)
                car.removeFromSuperview()
            }
        }
    }
    
    func addBarrier(barrier: UIView) {
        barriers.barriers.append(barrier)
    }
    
    func cleanBarrier() {
        
        guard let view = view?.getSuperView() else {
            return
        }
        
        for (index, barrier) in barriers.barriers.enumerated() {
            
            guard let barrierFrame = barrier.layer.presentation()?.frame else {
                continue
            }
            
            if barrierFrame.maxY > view.frame.maxY + 50 {
                barriers.barriers.remove(at: index)
                barrier.removeFromSuperview()
            }
        }
    }
    
    func addDividerStrip(dividerStrip: UIView) {
        dividerStrips.strips.append(dividerStrip)
    }
    
    func cleanDividerStrip() {
        
        guard let view = view?.getSuperView() else {
            return
        }
        
        for (index, strip) in dividerStrips.strips.enumerated() {
            
            guard let stripFrame = strip.layer.presentation()?.frame else {
                continue
            }
            
            if stripFrame.maxY > view.frame.maxY + 100 {
                dividerStrips.strips.remove(at: index)
                strip.removeFromSuperview()
            }
        }
    }
    
    func timerDividerStrip() {
        timerStrips = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(startNewDividerStrip), userInfo: nil, repeats: true)
    }
    
    func setupTimers() {
        timerTapInstruction = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(setupTapInstruction), userInfo: nil, repeats: true)
        
        timerPoints = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setupPoints), userInfo: nil, repeats: true)
        
        timerBarriers = Timer.scheduledTimer(timeInterval: getGameSpeedSettings().timerBarries, target: self, selector: #selector(startNewBarriers), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.timerCars = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.startNewCars), userInfo: nil, repeats: true)
        }
        
        timerCollisionChecker = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkCollisions), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startPlayer), userInfo: nil, repeats: false)
    }
    
    @objc func startNewDividerStrip() {
        view?.createDividerStrips()
    }
    
    @objc func setupTapInstruction() {
        view?.getTapInstructionsViews()
    }
    
    @objc func setupPoints() {
        numberOfPoints += 1
        view?.updatePointsLabel(with: numberOfPoints)
    }
    
    @objc func startNewBarriers() {
        view?.createBarriers()
    }
    
    @objc func startNewCars() {
        view?.createCars()
    }
    
    @objc func checkCollisions() {
        
        cleanCar()
        cleanBarrier()
        cleanDividerStrip()
        
        guard let carPlayer = view?.getPlayerCar() else { return }
        
        for car in cars.cars {
            guard let carPresentationFrame = car.layer.presentation()?.frame else {
                continue
            }
            
            if carPlayer.frame.intersects(carPresentationFrame) {
                
                for car in cars.cars {
                    car.layer.removeAllAnimations()
                }
                
                for barrier in barriers.barriers {
                    barrier.layer.removeAllAnimations()
                }
                
                guard let player = storageService?.loadPlayer() else { continue }
                storageService?.savePlayer(player)
                storageService?.saveRecords(player, score: numberOfPoints)
                
                allTimersClean()
                timerPoints?.invalidate()
                timerCars?.invalidate()
                timerBarriers?.invalidate()
                timerCollisionChecker?.invalidate()
                carPlayer.isHidden = true
                
                carPlayer.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 35, y: UIScreen.main.bounds.maxY + 70, width: 70, height: 100)
                
                cleaner()
                view?.showAlertAndStopGame()
                return
            }
        }
        
        for barrier in barriers.barriers {
            guard let barrierPresentationFrame = barrier.layer.presentation()?.frame else {
                continue
            }
            
            if carPlayer.frame.intersects(barrierPresentationFrame) {
                
                for car in cars.cars {
                    car.layer.removeAllAnimations()
                }
                
                for barrier in barriers.barriers {
                    barrier.layer.removeAllAnimations()
                }
                
                guard let player = storageService?.loadPlayer() else { continue }
                storageService?.savePlayer(player)
                storageService?.saveRecords(player, score: numberOfPoints)
                
                allTimersClean()
                timerPoints?.invalidate()
                timerCars?.invalidate()
                timerBarriers?.invalidate()
                timerCollisionChecker?.invalidate()
                carPlayer.isHidden = true
                
                carPlayer.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 35, y: UIScreen.main.bounds.maxY + 70, width: 70, height: 100)
                cleaner()
                view?.showAlertAndStopGame()
                return
            }
        }
    }
    
    @objc func startPlayer() {
        view?.setupPlayer()
    }
    
    // MARK: - SETUP CONTROL
    
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer, direction: Direction) {
        
        switch gestureRecognizer.state {
        case .began:
            startMovingCarRepeatedly(direction: direction)
        case .ended, .cancelled:
            stopMovingCar()
        default:
            break
        }
    }
    
    private func startMovingCarRepeatedly(direction: Direction) {
        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.moveCar(direction: direction)
        }
        moveTimer?.fire()
    }
    
    private func stopMovingCar() {
        moveTimer?.invalidate()
    }
    
    private func moveCar(direction: Direction) {
        let deltaX = direction == .left ? -5 : 5
        view?.moveCarAnimation(deltaX: CGFloat(deltaX))
    }
    
    private func cleaner() {
        for car in cars.cars {
            car.removeFromSuperview()
        }
        cars.cars.removeAll()
        
        for barrier in barriers.barriers {
            barrier.removeFromSuperview()
        }
        
        if barriers.barriers.isEmpty {
            barriers.barriers.removeAll()
        }
    }
    
    func getTupViewModels(direction: Direction) -> UIView {
        if direction == .left {
            return tapView.createTapView(imageName: .leftTapImageName, text: .leftTapText)
        } else {
            return tapView.createTapView(imageName: .rightTapImageName, text: .rightTapText)
        }
    }
    
    func allTimersClean() {
        timerStrips?.invalidate()
        timerBarriers?.invalidate()
        timerCars?.invalidate()
        timerCollisionChecker?.invalidate()
        timerTapInstruction?.invalidate()
        timerPoints?.invalidate()
        moveTimer?.invalidate()
    }
}
