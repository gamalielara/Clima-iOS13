//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
   
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.placeholder = "Please enter a city."
            return false
        } else {
            return true
        }
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func getWeather(_ weather: WeatherModel) {
        
        DispatchQueue.main.async(execute: {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        })
    }
    
    func didFailGetWeather(_ error: any Error) {
        print(error)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let currentLat = location.coordinate.latitude
            let currentLong = location.coordinate.longitude
            
            weatherManager.fetchWeather(lat: currentLat, long: currentLong)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }

}
