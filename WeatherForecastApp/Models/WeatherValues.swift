//
//  WeatherValues.swift
//  weather-forecast-app
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

struct WeatherValues: Decodable {
    let precipitationIntensity: Double?
    let precipitationType: Int?
    let windSpeed: Double
    let windGust: Double?
    let windDirection: Double?
    let temperature: Double
    let temperatureApparent: Double
    let cloudCover: Double?
    let cloudBase: Double?
    let cloudCeiling: Double?
    let weatherCode: Int
}
