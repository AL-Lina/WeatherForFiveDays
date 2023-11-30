//
//  ForecastCell.swift
//  WeatherForFiveDays
//
//  Created by Alina Sakovskaya on 26.11.23.
//

import UIKit

class ForecastCell: UICollectionViewCell {
        
    static var identifier: String {"\(Self.self)"}
    
    let weekdaylabel: UILabel = {
       let label = UILabel()
        label.text = "Monday"
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
    
    
    var dailyForecast: [WeatherInfo] = []
    var collectionView : UICollectionView!

    override init(frame: CGRect) {
         super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = Layer.cornerRadius
         contentView.layer.masksToBounds = true
        
        collectionView = UICollectionView(frame: CGRect(x: Frame.x, y: Frame.y, width: (frame.width - Frame.width), height: frame.height), collectionViewLayout: createCompositionalLayout())
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.identifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
       
        setupCells()
     }
    
    func setupCells() {
        addSubview(weekdaylabel)
        addSubview(tempSymbol)
        
        
        NSLayoutConstraint.activate([
            weekdaylabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            weekdaylabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.createFeaturedSection()
        }

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = configuration
        return layout
    }
        
    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(ItemSizeDimension.secondFractionalWidth), heightDimension: .fractionalHeight(ItemSizeDimension.secondFractionalHeight))

       let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: LayoutContentInsets.top, leading: LayoutContentInsets.leading, bottom: LayoutContentInsets.bottom, trailing: LayoutContentInsets.trailing)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(ItemSizeDimension.fractionalWidth), heightDimension: .estimated(ItemSizeDimension.estimated))
       let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

       let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
       layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

       return layoutSection
    }
    
    func configure(with item: ForecastTemperature) {
        weekdaylabel.text = item.weekDay
        dailyForecast = item.hourlyForecast ?? []
    }

}

extension ForecastCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCell.identifier, for: indexPath) as! HourlyCell
        cell.configure(with: dailyForecast[indexPath.row])
        return cell
    }
    
    
}

