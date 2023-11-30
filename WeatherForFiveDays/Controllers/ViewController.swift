//
//  ViewController.swift
//  WeatherForFiveDays
//
//  Created by Alina Sakovskaya on 26.11.23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    let networkManager = WeatherNetworkManager()
    
    let currentLocation: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "...Location"
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: Fonts.textFontSizeForLocation, weight: .heavy)
        return label
    }()
    
    let currentTime: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "28 March 2020"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: Fonts.textFontSizeForCurrentTime, weight: .heavy)
        return label
    }()
    
    let currentTemperatureLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°C"
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Fonts.textFontSizeForCurrentTemp, weight: .heavy)
        return label
    }()
    
    let tempDescription: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: Fonts.textFontSizeForСharacteristics, weight: .light)
        return label
    }()
    let tempSymbol: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(systemName: "cloud.fill")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .gray
        return img
    }()
    
    let maxTemp: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: Fonts.textFontSizeForСharacteristics, weight: .medium)
        return label
    }()
    
    let minTemp: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: Fonts.textFontSizeForСharacteristics, weight: .medium)
        return label
    }()
    
    let humidity: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °%"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: Fonts.textFontSizeForСharacteristics, weight: .medium)
        return label
    }()
    
    let pressure: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  hPa"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: Fonts.textFontSizeForСharacteristics, weight: .medium)
        return label
    }()
    
    let feelLikeTemp: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: Fonts.textFontSizeForСharacteristics, weight: .medium)
        return label
    }()
    
    
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var stackView : UIStackView!
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.adGradientBackgroundColor(firstColor: UIColor(red: Colors.firstRedColor, green: Colors.firstGreenColor, blue: Colors.firstBlueColor, alpha: Colors.alpha), secondColor: UIColor(red: Colors.secondRedColor, green: Colors.secondGreenColor, blue: Colors.secondBlueColor, alpha: Colors.alpha))
        
         self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton)), UIBarButtonItem(image: UIImage(systemName: "thermometer"), style: .done, target: self, action: #selector(handleShowForecast)),UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))]
         
        navigationController?.navigationBar.tintColor = .label
        
        transparentNavigationBar()
        setupScreen()
        setupLocations()
       
    }
    
    func setupLocations() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
             let formatter = DateFormatter()
             formatter.dateFormat = "dd MMM yyyy" //yyyy
             let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
             
             DispatchQueue.main.async {
                 self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
                 self.currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                 self.tempDescription.text = weather.weather[0].description
                 self.currentTime.text = stringDate
                 self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
                 self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                 self.feelLikeTemp.text = ("Feels like: " + String(weather.main.feels_like.kelvinToCeliusConverter()) + " °C")
                 self.humidity.text = ("Humidity: " + String(weather.main.humidity) + " %")
                 self.pressure.text = ("Pressure: " + String(weather.main.pressure) + " hPa")
                 self.tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                 UserDefaults.standard.set("\(weather.name ?? "")", forKey: UserDefaultsKeys.selectCity)
             }
         }
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
            print("Current Temperature", weather.main.temp.kelvinToCeliusConverter())
             let formatter = DateFormatter()
             formatter.dateFormat = "dd MMM yyyy" //yyyy
             let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
             DispatchQueue.main.async {
                 self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + " °C")
                 self.currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                 self.tempDescription.text = weather.weather[0].description
                 self.currentTime.text = stringDate
                 self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + " °C")
                 self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + " °C")
                 self.feelLikeTemp.text = ("Feels like: " + String(weather.main.feels_like.kelvinToCeliusConverter()) + " °C")
                 self.humidity.text = ("Humidity: " + String(weather.main.humidity) + " %")
                 self.pressure.text = ("Pressure: " + String(weather.main.pressure) + " hPa")
                 self.tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: UserDefaultsKeys.selectCity)
             }
        }
    }
    
    func setupScreen() {
        view.addSubview(currentLocation)
        view.addSubview(currentTemperatureLabel)
        view.addSubview(tempSymbol)
        view.addSubview(tempDescription)
        view.addSubview(currentTime)
        view.addSubview(minTemp)
        view.addSubview(maxTemp)
        view.addSubview(humidity)
        view.addSubview(pressure)
        view.addSubview(feelLikeTemp)
    
    
    
        NSLayoutConstraint.activate([
            currentLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ConstantsForViewController.topAnchorForLocation),
            currentLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantsForViewController.leadingAnchor),
            currentLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ConstantsForViewController.trailingAnchor),
            
            currentTime.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: ConstantsForViewController.topAnchorForTime),
            currentTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantsForViewController.leadingAnchor),
            currentTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ConstantsForViewController.trailingAnchor),
            
            currentTemperatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: ConstantsForViewController.centerYAnchorForTemp),
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantsForViewController.leadingAnchor),
            
            tempSymbol.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor),
            tempSymbol.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantsForViewController.leadingAnchor),
            
            tempDescription.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: ConstantsForViewController.topAnchorForTempDescription),
            tempDescription.leadingAnchor.constraint(equalTo: tempSymbol.trailingAnchor, constant: ConstantsForViewController.leadingAnchorForTempDescription),
    
            minTemp.topAnchor.constraint(equalTo: tempSymbol.bottomAnchor, constant: ConstantsForViewController.topAnchorForMinTemp),
            minTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantsForViewController.leadingAnchor),
        
            maxTemp.topAnchor.constraint(equalTo: minTemp.bottomAnchor),
            maxTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantsForViewController.leadingAnchor),
           
            feelLikeTemp.topAnchor.constraint(equalTo: maxTemp.bottomAnchor),
            feelLikeTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantsForViewController.leadingAnchor),
            
            humidity.topAnchor.constraint(equalTo: feelLikeTemp.bottomAnchor),
            humidity.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantsForViewController.leadingAnchor),
            
            pressure.topAnchor.constraint(equalTo: humidity.bottomAnchor),
            pressure.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantsForViewController.leadingAnchor)
        ])
        
    
    }

    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Find city weather", message: "", preferredStyle: .alert)
         alertController.addTextField { (textField : UITextField!) -> Void in
             textField.placeholder = "City Name"
         }
         let findAction = UIAlertAction(title: "Find", style: .default, handler: { alert -> Void in
             let firstTextField = alertController.textFields![0] as UITextField
            guard let cityname = firstTextField.text else { return }
            self.loadData(city: cityname)
         })
         let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            print("Cancel")
         })
      

         alertController.addAction(findAction)
         alertController.addAction(cancelAction)

         self.present(alertController, animated: true, completion: nil)
    }

    @objc func handleShowForecast() {
        self.navigationController?.pushViewController(ForecastViewController(), animated: true)
    }
    
    @objc func handleRefresh() {
        let city = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectCity) ?? ""
        loadData(city: city)
    }
    

    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
        title: "", style: .plain, target: nil, action: nil)
       
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        let location = locations[0].coordinate
        latitude = location.latitude
        longitude = location.longitude
        print("Long", longitude.description)
        print("Lat", latitude.description)
        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
    }
}
