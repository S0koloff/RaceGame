//
//  Menu.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 17.02.2024.
//

import UIKit
import SnapKit

private enum Constants {
    static let stackViewHeight = 280
    static let stackViewInset = 32
    
    static let buttonTitleSize = CGFloat(17)
    static let buttonTopOffset = 50
    static let buttonHeight = 60
}

private extension String {
    static let startGameButton = "Начать игру"
    static let settingsButton = "Настройки"
    static let scoreTableButton = "Таблица рекордов"
}

class MenuView: UIViewController {
    
    var presenter: MenuPresenter?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    func setupView() {
        let customButton = CustomButton()
        let startGameButton = customButton.createButton(title: .startGameButton,
                                                        titleSize: Constants.buttonTitleSize,
                                                        target: #selector(tapStartGame))
        let settingsButton = customButton.createButton(title: .settingsButton,
                                                       titleSize: Constants.buttonTitleSize,
                                                       target: #selector(tapSettings))
        let scoreTableButton = customButton.createButton(title: .scoreTableButton,
                                                         titleSize: Constants.buttonTitleSize,
                                                         target: #selector(tapRecords))
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(Constants.stackViewInset)
            make.height.equalTo(Constants.stackViewHeight)
        }
        
        stackView.addSubview(startGameButton)
        stackView.addSubview(settingsButton)
        stackView.addSubview(scoreTableButton)
        
        startGameButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.buttonHeight)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(startGameButton.snp.bottom).offset(Constants.buttonTopOffset)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.buttonHeight)
        }
        
        scoreTableButton.snp.makeConstraints { make in
            make.top.equalTo(settingsButton.snp.bottom).offset(Constants.buttonTopOffset)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    @objc func tapStartGame() {
        presenter?.startGame()
    }
    
    @objc func tapSettings() {
        presenter?.showSettings()
    }
    
    @objc func tapRecords() {
        presenter?.showRecords()
    }
}
