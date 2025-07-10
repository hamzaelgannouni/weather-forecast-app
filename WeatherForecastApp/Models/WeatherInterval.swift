//
//  WeatherInterval.swift
//  weather-forecast-app
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

struct WeatherInterval: Codable {
    let startTime: String
    let values: WeatherValues
    
    enum CodingKeys: String, CodingKey {
        case startTime, values
    }
}
