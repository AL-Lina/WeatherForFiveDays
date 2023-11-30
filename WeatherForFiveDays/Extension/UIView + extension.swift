//
//  UIView + extension.swift
//  WeatherForFiveDays
//
//  Created by Alina Sakovskaya on 27.11.23.
//

import UIKit

extension UIView {
    func adGradientBackgroundColor(firstColor: UIColor, secondColor: UIColor) {
        let gradientColor = CAGradientLayer()
        gradientColor.frame = bounds
        gradientColor.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientColor.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientColor.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(gradientColor, at: 0)
    }
}


