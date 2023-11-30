//
//  ConstantsForCells.swift
//  WeatherForFiveDays
//
//  Created by Alina Sakovskaya on 28.11.23.
//

import Foundation


enum Layer {
    static let cornerRadius: CGFloat = 10
}

enum Constraints {
    static let leadingAnchor: CGFloat = 8
    
    static let topAnchorForHourlyTime: CGFloat = 4
    static let heightTimeLabel: CGFloat = 10
    
    static let topAnchorForTempSymbol: CGFloat = 6
    static let heightTempSymbol: CGFloat = 40
    static let widthTempSymbol: CGFloat = 40
    
    static let heightTemp: CGFloat = 20
}

struct FontsForCells {
    static let hourlyTimeFontSize: CGFloat = 12
    static let tempFontSize: CGFloat = 16
}





