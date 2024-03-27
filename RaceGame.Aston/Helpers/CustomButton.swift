//
//  CustomButton.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 01.03.2024.
//

import UIKit

class CustomButton {
    
    func createButton(title: String, titleSize: CGFloat, target: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: titleSize)
        button.addTarget(self, action: target, for: .touchUpInside)
        return button
    }
    
    func createCircularButton(target: Selector) -> UIButton {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: target, for: .touchUpInside)
        return button
    }
}
