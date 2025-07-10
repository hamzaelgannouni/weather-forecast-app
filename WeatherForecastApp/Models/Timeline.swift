//
//  Timeline.swift
//  weather-forecast-app
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

struct Timeline: Codable {
    let timestep: String
    let startTime: String?
    let endTime: String?
    let intervals: [WeatherInterval]
}
