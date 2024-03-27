//
//  RecordsCell.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 12.03.2024.
//

import UIKit
import SnapKit

private enum Constants {
    // MARK: - Размеры и позиции элементов интерфейса
    static let nameSize: CGFloat = 16
    static let dateSize: CGFloat = 16
    static let pointsSize: CGFloat = 18
    static let avatarBorder: CGFloat = 2
    static let avatarBorderColor = UIColor.darkGray.cgColor
    static let leftRightOffset = 12
    static let avatarWidthHeight = 50
}

protocol RecordsViewDelegate {
    func getAvatar(player: Player) -> UIImage?
}

final class RecordsCell: UITableViewCell {
    
    static let identifire = "RecordsCell"
    
    var delegate: RecordsViewDelegate?
    
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFill
        return avatarImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: Constants.nameSize)
        return nameLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textAlignment = .right
        dateLabel.font = .systemFont(ofSize: Constants.dateSize)
        return dateLabel
    }()
    
    private lazy var points: UILabel = {
        let points = UILabel()
        points.font = .boldSystemFont(ofSize: Constants.pointsSize)
        return points
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(avatarImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(points)
        contentView.addSubview(dateLabel)
        
        avatarImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Constants.leftRightOffset)
            make.width.height.equalTo(Constants.avatarWidthHeight)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(avatarImage.snp.right).offset(Constants.leftRightOffset)
        }
        
        points.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(nameLabel.snp.right).offset(Constants.leftRightOffset)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(Constants.leftRightOffset)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.borderColor = Constants.avatarBorderColor
        avatarImage.layer.borderWidth = Constants.avatarBorder
        avatarImage.clipsToBounds = true
    }
    
    func setupPlayer(player: Player) {
        let avatar = delegate?.getAvatar(player: player)
        avatarImage.image = avatar
        nameLabel.text = player.name
        points.text = "\(player.topScore)"
        dateLabel.text = player.topScoreDate
    }
}
