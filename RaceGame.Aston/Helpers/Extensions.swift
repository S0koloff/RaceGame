//
//  Extensions.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 23.02.2024.
//

import UIKit

extension UIColor {
    static func getRandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowRadius = 10
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }
}

extension String {
    var hasLetter: Bool {
        return rangeOfCharacter(from: .letters, options: .caseInsensitive) != nil
    }
}

extension UITableView {
    func shouldEnableScrolling(within frame: CGRect) -> Bool {
        let safeAreaInsets = self.superview?.safeAreaInsets.top ?? 0.0
        let totalHeight = visibleCells.reduce(0) { $0 + $1.bounds.height }
        let availableHeight = frame.height - safeAreaInsets
        return totalHeight > availableHeight
    }
}

extension Date {
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}
