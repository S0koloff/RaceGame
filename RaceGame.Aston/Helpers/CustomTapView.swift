//
//  CustomTapView.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 28.02.2024.
//

import UIKit

class CustomTapView {
    func createTapView(imageName: String, text: String) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
        let textLabel = UILabel(frame: CGRect(x: 0, y: 120, width: 160, height: 20))
        
        image.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.text = text
        
        view.addSubview(image)
        view.addSubview(textLabel)
        
        return view
    }
}
