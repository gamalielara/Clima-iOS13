//
//  File.swift
//  Clima
//
//  Created by Ara Gamaliel on 5/22/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [WeatherInfo]
    
}

struct Main: Decodable {
    let temp: Double
}

struct WeatherInfo: Decodable {
    let id: Int
    let main: String
    let description: String
}
