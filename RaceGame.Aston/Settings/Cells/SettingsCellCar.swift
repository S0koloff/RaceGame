//
//  SettingsCellCar.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 01.03.2024.
//

import UIKit

private enum Constants {
    // MARK: - Размеры и позиции элементов интерфейса
    static let titleSize: CGFloat = 14
    static let carPlayerCornerRadius: CGFloat = 25
    static let carWidth = 70
    static let carHeight = 100
    static let carOffset = 36
    static let buttonOffset = 15
    static let buttonWidth = 150
    static let buttonHeight = 35
}

private extension String {
    static let colorButtonTitle = "Изменить машину"
}

protocol SettingsCellCarDelegate: AnyObject {
    func getNewColor()
}

final class SettingsCellCar: UITableViewCell {
    
    static let identifire = "SettingsCellCar"
    
    weak var delegate: SettingsCellCarDelegate?
    
    private lazy var carPlayer: UIView = {
        let carPlayer = UIView()
        carPlayer.backgroundColor = .black
        carPlayer.layer.cornerRadius = Constants.carPlayerCornerRadius
        return carPlayer
    }()
    
    private lazy var getCarColorButton = CustomButton().createButton(title: .colorButtonTitle,
                                                                     titleSize: Constants.titleSize,
                                                                     target: #selector(getColor))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(carPlayer)
        contentView.addSubview(getCarColorButton)
        
        carPlayer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset( Constants.carOffset)
            make.width.equalTo(Constants.carWidth)
            make.height.equalTo( Constants.carHeight)
        }
        
        getCarColorButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(carPlayer.snp.bottom).offset( Constants.buttonOffset)
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        carPlayer.dropShadow()
    }
    
    func setupCarColor(player: Player) {
        carPlayer.backgroundColor = player.carUIColor
    }
    
    @objc func getColor() {
        delegate?.getNewColor()
    }
}
