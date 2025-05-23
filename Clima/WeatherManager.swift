//
//  File.swift
//  Clima
//
//  Created by Ara Gamaliel on 5/22/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let apiKey = "f8e0e2fe242106fa447e4c7f1c33b75a"
    let weatherURL: String
    
    var delegate: WeatherManagerDelegate?
        
    init(){
        self.weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(self.apiKey)&units=metric"
    }
    
    func fetchWeather(cityName: String) {
        let urlString = "\(self.weatherURL)&q=\(cityName)"
        
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(lat: Double, long: Double){
        let urlString = "\(self.weatherURL)&lat=\(lat)&lon=\(long)"
        
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        // 1. Create URL
        if let url = URL(string: urlString) {
            // 2. Create URLSession
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let safeData = data {
                    // Parse JSON to swift Object
                    let decoder = JSONDecoder()
                    
                    do {
                        let decodedData = try decoder.decode(WeatherData.self, from: safeData)
                        
                        let conditionID = decodedData.weather[0].id
                        let temp = decodedData.main.temp
                        let cityName = decodedData.name
                        
                        let weather = WeatherModel(conditionId: conditionID, cityName: cityName, temperature: temp)
                        
                        print(weather)
                        
                        self.delegate?.getWeather(weather)
                        
                        
                    } catch {
                        self.delegate?.didFailGetWeather(error)
                        print(error)
                    }
                }
            })
            
            // 4. Start the stask
            task.resume()
        }
    }
}

enum WeatherErrorEnum: Error {
    case invalidLongitudeOrLatitude
}
