//
//  MockWeatherCacheService.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

class MockWeatherCacheService: WeatherCacheServiceProtocol {
    private var cachedData: WeatherResponse?
    private var cacheDate: Date?
    var shouldFail = false
    var mockError: CacheServiceError = .fileSystemError
    
    func cacheWeatherData(_ data: WeatherResponse) async throws {
        if shouldFail {
            throw mockError
        }
        cachedData = data
        cacheDate = Date()
    }
    
    func getCachedWeatherData() async throws -> WeatherResponse? {
        if shouldFail {
            throw mockError
        }
        return cachedData
    }
    
    func clearCache() async throws {
        if shouldFail {
            throw mockError
        }
        cachedData = nil
        cacheDate = nil
    }
    
    func getCacheDate() async -> Date? {
        return cacheDate
    }
}
