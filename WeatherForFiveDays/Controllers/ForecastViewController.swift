//
//  ForecastViewController.swift
//  WeatherForFiveDays
//
//  Created by Alina Sakovskaya on 26.11.23.
//

import UIKit

class ForecastViewController : UIViewController {
 
    let networkManager = WeatherNetworkManager()
    var collectionView : UICollectionView!
    var forecastData: [ForecastTemperature] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.adGradientBackgroundColor(firstColor: UIColor(red: Colors.firstRedColor, green: Colors.firstGreenColor, blue: Colors.firstBlueColor, alpha: Colors.alpha), secondColor: UIColor(red: Colors.secondRedColor, green: Colors.secondGreenColor, blue: Colors.secondBlueColor, alpha: Colors.alpha))
        self.title = "Weather for 5 days"

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        setupCollectionView()
        let city = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectCity) ?? ""
        networkManager.fetchNextFiveWeatherForecast(city: city) { (forecast) in
            self.forecastData = forecast
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        forecastData = []
    }
    
    
    func setupCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ConstantsForForecastViewController.topAnchorForCollectionView),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.createFeaturedSection()
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(ItemSizeDimension.fractionalWidth), heightDimension: .fractionalHeight(ItemSizeDimension.fractionalHeight))

       let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: LayoutContentInsets.top, leading: LayoutContentInsets.leading, bottom: LayoutContentInsets.bottom, trailing: LayoutContentInsets.trailing)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(ItemSizeDimension.fractionalWidth), heightDimension: .estimated(ItemSizeDimension.estimated))
       let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

       let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

       return layoutSection
}
}

extension ForecastViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastData.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.identifier, for: indexPath) as! ForecastCell
        cell.configure(with: forecastData[indexPath.row])
        return cell
     }
}


