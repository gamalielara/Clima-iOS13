//
//  WeatherManagerDelegate.swift
//  Clima
//
//  Created by Ara Gamaliel on 5/22/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func getWeather(_ weather: WeatherModel) -> Void
    func didFailGetWeather(_ error: Error) -> Void
}
