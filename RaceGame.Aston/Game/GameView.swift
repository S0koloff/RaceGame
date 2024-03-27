//
//  GameView.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 14.02.2024.
//

import UIKit

private enum Constants {
    // MARK: - Размеры и позиции элементов интерфейса
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let carWidth: CGFloat = 70
    static let carHeight: CGFloat = 100
    static let barrierWidth: CGFloat = 50
    static let barrierHeight: CGFloat = 50
    static let controlWidth = screenWidth / 2
    static let controlHeight = screenHeight
    static let roadWidth = screenWidth - 140
    static let roadHeight = screenHeight
    static let roadX: CGFloat = 70
    static let carPlayerX = screenWidth / 2 - 35
    static let carPlayerY = UIScreen.main.bounds.maxY + 70
    static let carPlayerAnimationEndY = UIScreen.main.bounds.maxY - 250
    static let instrctionViewLeftX: CGFloat = 20
    static let instrctionViewLeftY: CGFloat = screenHeight / 2
    static let instrctionViewRightX: CGFloat = UIScreen.main.bounds.maxX - 140
    static let instrctionViewRightY: CGFloat = screenHeight / 2
    static let instrctionViewWidth: CGFloat = 100
    static let instrctionViewHeight: CGFloat = 120
    static let dividerStripWidth: CGFloat = 5
    static let dividerStripHeight: CGFloat = 100
    static let dividerStripX: CGFloat = screenWidth / 2
    static let pointsY = 40
    static let pointsHeight = 50
    static let pointsFont = 36
    
    // MARK: - Длительности анимаций и других процессов
    static let carAnimationDuration: TimeInterval = 2
    static let carMoveDuration: TimeInterval = 0.2
    static let instructionsAnimationDuration: TimeInterval = 2
    static let minLongPressDuration: TimeInterval = 0.01
    
    // MARK: - Цвета и стили
    static let roadColor = UIColor.gray
    static let dividerStripColor = UIColor.white
    static let carCornerRadius: CGFloat = 25
}

private extension String {
    static let keyPath = "position"
    static let keyBarrier = "barrierMove"
    static let keyCars = "carsMove"
    static let keyDividerStrips = "dividerStripsMove"
    
    static let alertTitle = "Игра окончена"
    static let alertMessageFormat = "Ваш счет: %d"
    static let alertActionBack = "Назад"
    static let alertActionRepeat = "Повтор"
    
    static func alertMessage(with points: Int) -> String {
        return String(format: alertMessageFormat, points)
    }
}

protocol GameViewDelegate: AnyObject {
    func setupPlayer()
    func createCars()
    func createBarriers()
    func createDividerStrips()
    func getTapInstructionsViews()
    func moveCarAnimation(deltaX: CGFloat)
    func updatePointsLabel(with numberOfPoints: Int)
    func getPlayerCar() -> UIView
    func showAlertAndStopGame()
    func getCarColor(color: UIColor)
    func getSuperView() -> UIView
}

final class GameViewController: UIViewController, GameViewDelegate {
    
    var presenter: GamePresenter?
    
    private var leftTapView: UIView?
    private var rightTapView: UIView?
    
    private lazy var points: UILabel = {
        let points = UILabel(frame: CGRect(x: 0, y: Constants.pointsY, width: Int(Constants.screenWidth), height: Constants.pointsHeight))
        points.textAlignment = .center
        points.font = UIFont.boldSystemFont(ofSize: CGFloat(Constants.pointsFont))
        return points
    }()
    
    private lazy var road: UIView = {
        let road = UIView(frame: CGRect(x: Constants.roadX, y: 0, width: Constants.roadWidth, height: Constants.roadHeight))
        road.backgroundColor = Constants.roadColor
        return road
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight))
        return stackView
    }()
    
    private lazy var leftControl: UIView = {
        let leftControl = UIView(frame: CGRect(x: 0, y: 0, width: Constants.controlWidth, height: Constants.controlHeight))
        leftControl.isUserInteractionEnabled = true
        return leftControl
    }()
    
    private lazy var rightControl: UIView = {
        let rightControl = UIView(frame: CGRect(x: Constants.controlWidth, y: 0, width: Constants.controlWidth, height: Constants.controlHeight))
        rightControl.isUserInteractionEnabled = true
        return rightControl
    }()
    
    private lazy var carPlayer: UIView = {
        let carPlayer = UIView(frame: CGRect(x: Constants.carPlayerX, y: Constants.carPlayerY, width: Constants.carWidth, height: Constants.carHeight))
        carPlayer.layer.cornerRadius = Constants.carCornerRadius
        carPlayer.dropShadow()
        return carPlayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupView()
        presenter?.startNewGame()
        setupLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupView() {
        
        view.addSubview(stackView)
        view.addSubview(points)
        stackView.addSubview(road)
        
        createIntstructionViews()
    }
    
    private func createIntstructionViews() {
        leftTapView = presenter?.getTupViewModels(direction: .left)
        rightTapView = presenter?.getTupViewModels(direction: .right)
        
        guard let lTapView = leftTapView else {
            return
        }
        
        guard let rTapView = rightTapView else {
            return
        }
        
        lTapView.frame = CGRect(x: Constants.instrctionViewLeftX, y: Constants.instrctionViewLeftY, width: Constants.instrctionViewWidth, height: Constants.instrctionViewHeight)
        rTapView.frame = CGRect(x: Constants.instrctionViewRightX, y: Constants.instrctionViewRightY, width: Constants.instrctionViewWidth, height: Constants.instrctionViewHeight)
        
        view.addSubview(lTapView)
        view.addSubview(rTapView)
    }
    
    func updatePointsLabel(with numberOfPoints: Int) {
        points.text = "\(numberOfPoints)"
    }
    
    // MARK: - PLAYER
    
    func getCarColor(color: UIColor) {
        self.carPlayer.backgroundColor = color
    }
    
    func getPlayerCar() -> UIView {
        return carPlayer
    }
    
    func setupPlayer() {
        UIView.animate(withDuration: Constants.carAnimationDuration) {
            self.carPlayer.frame = CGRect(x: Constants.carPlayerX, y: Constants.carPlayerAnimationEndY, width: Constants.carWidth, height: Constants.carHeight)
        }
        view.addSubview(carPlayer)
    }
    
    // MARK: - SETUP BARRIERS
    
    private func animationBarriers() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .keyPath)
        
        let randomValue = [view.bounds.maxX - 35, view.bounds.minX + 35][Int(arc4random_uniform(2))]
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: randomValue, y: view.bounds.minY - 80))
        animation.toValue = NSValue(cgPoint: CGPoint(x: randomValue, y: view.bounds.maxY + 80))
        animation.duration = (presenter?.getGameSpeedSettings().durationBarriers)!
        animation.fillMode = .forwards
        animation.repeatCount = Float.infinity
        return animation
    }
    
    func createBarriers() {
        let barrier = UIView(frame: CGRect(x: 0, y: view.bounds.minY - 80, width: Constants.barrierWidth, height: Constants.barrierHeight))
        barrier.dropShadow()
        let randomIndex = arc4random_uniform(2)
        
        guard let three = presenter?.setupBarrierThree() else { return }
        guard let stone = presenter?.setupBarrierStone() else { return }
        
        if randomIndex == 0 {
            if three == true {
                barrier.layer.cornerRadius = 10
                barrier.backgroundColor = .brown
            } else {
                barrier.isHidden = true
            }
        } else {
            if stone == true {
                barrier.layer.cornerRadius = barrier.frame.width / 2
                barrier.backgroundColor = .lightGray
            } else {
                barrier.isHidden = true
            }
        }
        
        barrier.layer.add(self.animationBarriers(), forKey: .keyBarrier)
        stackView.addSubview(barrier)
        
        presenter?.addBarrier(barrier: barrier)
        presenter?.cleanBarrier()
    }
    
    // MARK: - SETUP CARS
    
    private func animationCars() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .keyPath)
        
        let randomValue = [UIScreen.main.bounds.width / 2 - 65, UIScreen.main.bounds.width / 2 + 65][Int(arc4random_uniform(2))]
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: randomValue, y:  UIScreen.main.bounds.minY - 100))
        animation.toValue = NSValue(cgPoint: CGPoint(x: randomValue, y:  UIScreen.main.bounds.maxY + 100))
        animation.duration = (presenter?.getGameSpeedSettings().durationCars)!
        animation.fillMode = .forwards
        animation.repeatCount = Float.infinity
        return animation
    }
    
    func createCars() {
        let car = UIView(frame: CGRect(x: 0, y:  self.view.bounds.minY - 120, width: Constants.carWidth, height: Constants.carHeight))
        car.backgroundColor = .getRandomColor()
        car.layer.cornerRadius = Constants.carCornerRadius
        car.dropShadow()
        car.layer.add(self.animationCars(), forKey: .keyCars)
        
        self.stackView.addSubview(car)
        
        presenter?.addCar(car: car)
    }
    
    // MARK: - SETUP DIVIDER STRIPS
    
    func getSuperView() -> UIView {
        return self.view
    }
    
    private func animationDividerStrips() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .keyPath)
        animation.fromValue = NSValue(cgPoint: CGPoint(x: Constants.dividerStripX, y: view.bounds.minY - 40))
        animation.toValue = NSValue(cgPoint: CGPoint(x: Constants.dividerStripX, y: view.bounds.maxY + 40))
        animation.duration = (presenter?.getGameSpeedSettings().durationDividers)!
        animation.fillMode = .forwards
        animation.repeatCount = Float.infinity
        return animation
    }
    
    func createDividerStrips() {
        let dividerStrip = UIView(frame: CGRect(x: Constants.dividerStripX, y: view.bounds.minY - 100, width: Constants.dividerStripWidth, height: Constants.dividerStripHeight))
        dividerStrip.backgroundColor = Constants.dividerStripColor
        dividerStrip.layer.add(animationDividerStrips(), forKey: .keyDividerStrips)
        
        stackView.addSubview(dividerStrip)
        
        presenter?.addDividerStrip(dividerStrip: dividerStrip)
        presenter?.cleanDividerStrip()
    }
    
    // MARK: - SETUP CONTROL
    
    func getTapInstructionsViews() {
        UIView.animate(withDuration: Constants.instructionsAnimationDuration) {
            self.leftTapView?.alpha = 0
            self.rightTapView?.alpha = 0
        } completion: { _ in
            self.leftTapView?.removeFromSuperview()
            self.rightTapView?.removeFromSuperview()
        }
    }
    
    func setupLongPressGesture() {
        view.addSubview(leftControl)
        view.addSubview(rightControl)
        
        let leftLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(leftLongPress(_:)))
        leftLongPressGestureRecognizer.minimumPressDuration = Constants.minLongPressDuration
        leftControl.addGestureRecognizer(leftLongPressGestureRecognizer)
        
        let rightLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(rightLongPress(_:)))
        rightLongPressGestureRecognizer.minimumPressDuration = Constants.minLongPressDuration
        rightControl.addGestureRecognizer(rightLongPressGestureRecognizer)
    }
    
    @objc func leftLongPress(_ sender: UILongPressGestureRecognizer) {
        presenter?.handleLongPress(sender, direction: .left)
    }
    
    @objc func rightLongPress(_ sender: UILongPressGestureRecognizer) {
        presenter?.handleLongPress(sender, direction: .right)
    }
    
    func moveCarAnimation(deltaX: CGFloat) {
        let minX = view.frame.minX
        let maxX = view.frame.maxX
        
        if carPlayer.frame.minX + deltaX >= minX && carPlayer.frame.maxX + deltaX <= maxX {
            UIView.animate(withDuration: Constants.carMoveDuration) {
                self.carPlayer.frame.origin.x += deltaX
            }
        }
    }
    
    func showAlertAndStopGame() {
        
        guard let points = presenter?.numberOfPoints else {
            return
        }
        
        let alertController = UIAlertController(title: .alertTitle, message: .alertMessage(with: points), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: .alertActionBack, style: .default, handler: { [weak self] _ in
            self?.presenter?.allTimersClean()
            self?.navigationController?.popViewController(animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: .alertActionRepeat, style: .default, handler: { [weak self] _ in
            alertController.dismiss(animated: true)
            self?.carPlayer.isHidden = false
            self?.presenter?.numberOfPoints = 0
            self?.presenter?.setupTimers()
        }))
        
        present(alertController, animated: true)
    }
}
