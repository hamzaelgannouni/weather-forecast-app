//
//  WeatherCacheServiceProtocol.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

protocol WeatherCacheServiceProtocol {
    func cacheWeatherData(_ data: WeatherResponse) async throws
    func getCachedWeatherData() async throws -> WeatherResponse?
    func clearCache() async throws
    func getCacheDate() async -> Date?
}
