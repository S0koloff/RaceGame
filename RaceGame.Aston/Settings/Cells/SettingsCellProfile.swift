//
//  SettingsTVCell.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 01.03.2024.
//

import UIKit
import SnapKit

private enum Constants {
    // MARK: - Размеры и позиции элементов интерфейса
    static let renameTitleSize: CGFloat = 14
    static let avatarImageInset = 8
    static let avatarHeightWidth = 100
    static let pencilXOffset = 45
    static let pencilYOffset = 35
    static let pencilHeightWidth = 25
    static let nameOffset = 5
    static let nameHeight = 50
    static let renameOffset = 5
    static let renameWidth = 150
    static let renameHeight = 35
    
    // MARK: - Цвета и стили
    static let avatarBorder: CGFloat = 2
    static let avatarBorderColor = UIColor.darkGray.cgColor
    static let pencilImageTintColor: UIColor = .darkGray
    static let nameLabelFont = UIFont.boldSystemFont(ofSize: 26)
}

private extension String {
    static let pencilImageName = "pencil"
    static let renameTitle = "Изменить имя"
    static let barrierStoneLabel = "Включить камни"
    static let gameSpeedX1Label = "Включить скорость х1"
    static let gameSpeedX2Label = "Включить скорость х2"
}

protocol SettingsCellProfileDelegate: AnyObject {
    func changeNickname()
    func changeAvatar()
}

final class SettingsCellProfile: UITableViewCell {
    
    static let identifire = "SettingsCellProfile"
    
    weak var delegate: SettingsCellProfileDelegate?
    
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.borderWidth = Constants.avatarBorder
        avatarImage.layer.borderColor = Constants.avatarBorderColor
        return avatarImage
    }()
    
    private lazy var pencilImage: UIImageView = {
        let pencilImage = UIImageView()
        pencilImage.contentMode = .scaleAspectFill
        pencilImage.image = UIImage(systemName: .pencilImageName)
        pencilImage.tintColor = Constants.pencilImageTintColor
        return pencilImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = Constants.nameLabelFont
        return nameLabel
    }()
    
    private lazy var rename = CustomButton().createButton(title: .renameTitle,
                                                          titleSize: Constants.renameTitleSize,
                                                          target: #selector(renameTap))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        contentView.addSubview(avatarImage)
        contentView.addSubview(pencilImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rename)
        
        avatarImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.avatarImageInset)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Constants.avatarHeightWidth)
        }
        
        pencilImage.snp.makeConstraints { make in
            make.centerX.equalTo(avatarImage).offset(Constants.pencilXOffset)
            make.centerY.equalTo(avatarImage).offset(Constants.pencilYOffset)
            make.height.width.equalTo(Constants.pencilHeightWidth)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.bottom).offset(Constants.nameOffset)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.nameHeight)
        }
        
        rename.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.renameOffset)
            make.width.equalTo(Constants.renameWidth)
            make.height.equalTo(Constants.renameHeight)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.layer.masksToBounds = true
        avatarImage.clipsToBounds = true
    }
    
    func setupUser(user: Player, avatar: UIImage) {
        nameLabel.text = "\(user.name)"
        avatarImage.image = avatar
    }
    
    func setupGesture() {
        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapAction(_:)))
        avatarImage.addGestureRecognizer(avatarTapGesture)
        avatarImage.isUserInteractionEnabled = true
    }
    
    @objc func avatarTapAction(_ sender: UITapGestureRecognizer) {
        delegate?.changeAvatar()
    }
    
    @objc func renameTap() {
        delegate?.changeNickname()
    }
}
