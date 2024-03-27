//
//  SettingsCellGame.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 01.03.2024.
//

import UIKit

private enum Constants {
    // MARK: - Размеры и позиции элементов интерфейса
    static let titleSize = CGFloat(18)
    static let labelSize = CGFloat(16)
    static let titleTopOffset = 16
    static let firstLableOffset = 26
    static let labelOffset = 22
    static let labelLeftRightInset = 32
    static let labelTopOffset = 22
    static let widthHeightButton = 25
}

private extension String {
    static let titleLabel = "Настройка игры"
    static let barrierThreeLabel = "Включить деревья"
    static let barrierStoneLabel = "Включить камни"
    static let gameSpeedX1Label = "Включить скорость х1"
    static let gameSpeedX2Label = "Включить скорость х2"
}

protocol SettingsCellGameDelegate: AnyObject {
    func setThree()
    func setStone()
    func setGameSpeed(x2: Bool)
}

final class SettingsCellGame: UITableViewCell {
    
    static let identifire = "SettingsCellGame"
    
    weak var delegate: SettingsCellGameDelegate?
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleSize)
        titleLabel.text = .titleLabel
        return titleLabel
    }()
    
    private lazy var barrierThreeLabel: UILabel = {
        let barrierThreeLabel = UILabel()
        barrierThreeLabel.textAlignment = .center
        barrierThreeLabel.font = UIFont.systemFont(ofSize: Constants.labelSize)
        barrierThreeLabel.text = .barrierThreeLabel
        return barrierThreeLabel
    }()
    
    private lazy var barrierStoneLabel: UILabel = {
        let barrierStoneLabel = UILabel()
        barrierStoneLabel.textAlignment = .center
        barrierStoneLabel.font = UIFont.systemFont(ofSize: Constants.labelSize)
        barrierStoneLabel.text = .barrierStoneLabel
        return barrierStoneLabel
    }()
    
    private lazy var gameSpeedX1Label: UILabel = {
        let gameSpeedX1Label = UILabel()
        gameSpeedX1Label.textAlignment = .center
        gameSpeedX1Label.font = UIFont.systemFont(ofSize: Constants.labelSize)
        gameSpeedX1Label.text = .gameSpeedX1Label
        return gameSpeedX1Label
    }()
    
    private lazy var gameSpeedX2Label: UILabel = {
        let gameSpeedX2Label = UILabel()
        gameSpeedX2Label.textAlignment = .center
        gameSpeedX2Label.font = UIFont.systemFont(ofSize: Constants.labelSize)
        gameSpeedX2Label.text = .gameSpeedX2Label
        return gameSpeedX2Label
    }()
    
    private lazy var barrierThree = CustomButton().createCircularButton(target: #selector(setBarrierThree))
    private lazy var barrierStone = CustomButton().createCircularButton(target: #selector(setBarrierStone))
    private lazy var gameSpeedX1 = CustomButton().createCircularButton(target: #selector(setGameSpeedX1))
    private lazy var gameSpeedX2 = CustomButton().createCircularButton(target: #selector(setGameSpeedX2))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(barrierThree)
        contentView.addSubview(barrierStone)
        contentView.addSubview(barrierThreeLabel)
        contentView.addSubview(barrierStoneLabel)
        contentView.addSubview(gameSpeedX1Label)
        contentView.addSubview(gameSpeedX2Label)
        contentView.addSubview(gameSpeedX1)
        contentView.addSubview(gameSpeedX2)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.titleTopOffset)
            make.left.right.equalToSuperview()
        }
        
        barrierThreeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.firstLableOffset)
            make.left.equalToSuperview().inset(Constants.labelLeftRightInset)
        }
        
        barrierThree.snp.makeConstraints { make in
            make.centerY.equalTo(barrierThreeLabel)
            make.right.equalToSuperview().inset(Constants.labelLeftRightInset)
            make.width.equalTo(Constants.widthHeightButton)
            make.height.equalTo(Constants.widthHeightButton)
        }
        
        barrierStoneLabel.snp.makeConstraints { make in
            make.top.equalTo(barrierThreeLabel.snp.bottom).offset(Constants.labelTopOffset)
            make.left.equalToSuperview().inset(Constants.labelLeftRightInset)
        }
        
        barrierStone.snp.makeConstraints { make in
            make.centerY.equalTo(barrierStoneLabel)
            make.right.equalToSuperview().inset(Constants.labelLeftRightInset)
            make.width.equalTo(Constants.widthHeightButton)
            make.height.equalTo(Constants.widthHeightButton)
        }
        
        gameSpeedX1Label.snp.makeConstraints { make in
            make.top.equalTo(barrierStoneLabel.snp.bottom).offset(Constants.labelTopOffset)
            make.left.equalToSuperview().inset(Constants.labelLeftRightInset)
        }
        
        gameSpeedX1.snp.makeConstraints { make in
            make.centerY.equalTo(gameSpeedX1Label)
            make.right.equalToSuperview().inset(Constants.labelLeftRightInset)
            make.width.equalTo(Constants.widthHeightButton)
            make.height.equalTo(Constants.widthHeightButton)
        }
        
        gameSpeedX2Label.snp.makeConstraints { make in
            make.top.equalTo(gameSpeedX1Label.snp.bottom).offset(Constants.labelTopOffset)
            make.left.equalToSuperview().inset(Constants.labelLeftRightInset)
        }
        
        gameSpeedX2.snp.makeConstraints { make in
            make.centerY.equalTo(gameSpeedX2Label)
            make.right.equalToSuperview().inset(Constants.labelLeftRightInset)
            make.width.equalTo(Constants.widthHeightButton)
            make.height.equalTo(Constants.widthHeightButton)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButtons()
    }
    
    private func setupButtons() {
        barrierThree.layer.cornerRadius = barrierThree.frame.width / 2
        barrierThree.layer.masksToBounds = true
        barrierStone.layer.cornerRadius = barrierStone.frame.width / 2
        barrierStone.layer.masksToBounds = true
        gameSpeedX1.layer.cornerRadius = gameSpeedX1.frame.width / 2
        gameSpeedX1.layer.masksToBounds = true
        gameSpeedX2.layer.cornerRadius = gameSpeedX2.frame.width / 2
        gameSpeedX2.layer.masksToBounds = true
    }
    
    func setupSettings(three: Bool, stone: Bool, gameSpeedX2: Bool) {
        if three == true {
            barrierThree.backgroundColor = .darkGray
        } else {
            barrierThree.backgroundColor = .white
        }
        
        if stone == true {
            barrierStone.backgroundColor = .darkGray
        } else {
            barrierStone.backgroundColor = .white
        }
        
        if gameSpeedX2 == true {
            self.gameSpeedX2.backgroundColor = .darkGray
            gameSpeedX1.backgroundColor = .white
        } else {
            self.gameSpeedX2.backgroundColor = .white
            gameSpeedX1.backgroundColor = .darkGray
        }
    }
    
    @objc private func setBarrierThree() {
        delegate?.setThree()
    }
    
    @objc private func setBarrierStone() {
        delegate?.setStone()
    }
    
    @objc private func setGameSpeedX1() {
        delegate?.setGameSpeed(x2: false)
    }
    
    @objc private func setGameSpeedX2() {
        delegate?.setGameSpeed(x2: true)
    }
}
