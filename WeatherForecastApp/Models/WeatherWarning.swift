//
//  WeatherWarning.swift
//  weather-forecast-app
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

struct WeatherWarning: Codable {
    let code: Int
    let type: String
    let message: String
    let meta: WarningMeta?
}
