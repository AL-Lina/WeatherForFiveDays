//
//  HourlyCell.swift
//  WeatherForFiveDays
//
//  Created by Alina Sakovskaya on 26.11.23.
//

import UIKit

class HourlyCell: UICollectionViewCell {
        
    static var identifier: String {"\(Self.self)"}
    
    let hourlyTimeLabel: UILabel = {
       let label = UILabel()
        label.text = "05:00"
        label.font = UIFont.systemFont(ofSize: FontsForCells.hourlyTimeFontSize)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tempSymbol: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let tempLabel: UILabel = {
       let label = UILabel()
        label.text = "05:00"
        label.font = UIFont.systemFont(ofSize: FontsForCells.tempFontSize)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = Layer.cornerRadius
         contentView.layer.masksToBounds = true
    
        
         setupCells()
     }
    
    func setupCells() {
        addSubview(hourlyTimeLabel)
        addSubview(tempSymbol)
        addSubview(tempLabel)
        
        NSLayoutConstraint.activate([
            hourlyTimeLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.topAnchorForHourlyTime),
            hourlyTimeLabel.heightAnchor.constraint(equalToConstant: Constraints.heightTimeLabel),
            hourlyTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            hourlyTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tempSymbol.topAnchor.constraint(equalTo: hourlyTimeLabel.bottomAnchor, constant: Constraints.topAnchorForTempSymbol),
            tempSymbol.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempSymbol.heightAnchor.constraint(equalToConstant: Constraints.heightTempSymbol),
            tempSymbol.widthAnchor.constraint(equalToConstant: Constraints.widthTempSymbol),
            
            tempLabel.topAnchor.constraint(equalTo: tempSymbol.bottomAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tempLabel.heightAnchor.constraint(equalToConstant: Constraints.heightTemp)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: WeatherInfo) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        if let date = dateFormatterGet.date(from: item.time) {
            hourlyTimeLabel.text = dateFormatter.string(from: date)
        }
        
        tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(item.icon)@2x.png")
        tempLabel.text = String(item.temp.kelvinToCeliusConverter()) + " °C"
    }
}


