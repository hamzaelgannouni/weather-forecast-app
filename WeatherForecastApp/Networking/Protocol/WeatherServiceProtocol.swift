//
//  WeatherServiceProtocol.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeatherData() async throws -> WeatherResponse
}
