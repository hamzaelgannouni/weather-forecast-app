//
//  WeatherResponse.swift
//  weather-forecast-app
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

struct WeatherResponse: Decodable {
    let data: WeatherData
    let warnings: [WeatherWarning]?
}
