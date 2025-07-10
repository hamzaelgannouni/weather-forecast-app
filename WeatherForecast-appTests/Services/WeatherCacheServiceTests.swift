//
//  WeatherCacheServiceTests.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import XCTest
@testable import WeatherForecastApp

class WeatherCacheServiceTests: XCTestCase {
    
    var cacheService: WeatherCacheService!
    var mockWeatherResponse: WeatherResponse!
    
    override func setUp() {
        super.setUp()
        cacheService = WeatherCacheService()
        mockWeatherResponse = createMockWeatherResponse()
    }
    
    override func tearDown() async throws {
        try await cacheService.clearCache()
        cacheService = nil
        mockWeatherResponse = nil
        try await super.tearDown()
    }

    
    func testCacheAndRetrieveWeatherData() async throws {
        let weatherData = mockWeatherResponse!
        try await cacheService.cacheWeatherData(weatherData)
        let cachedData = try await cacheService.getCachedWeatherData()
        
        XCTAssertNotNil(cachedData)
        XCTAssertEqual(cachedData?.data.timelines.count, weatherData.data.timelines.count)
        XCTAssertEqual(cachedData?.data.timelines.first?.timestep, weatherData.data.timelines.first?.timestep)
        XCTAssertEqual(cachedData?.data.timelines.first?.intervals.count, weatherData.data.timelines.first?.intervals.count)
    }
    
    // MARK: - Test Cache Date
    func testCacheDate() async throws {
        let beforeCaching = Date()
        try await cacheService.cacheWeatherData(mockWeatherResponse)
        let cacheDate = await cacheService.getCacheDate()
        let afterCaching = Date()
        
        XCTAssertNotNil(cacheDate)
        XCTAssertGreaterThanOrEqual(cacheDate!, beforeCaching)
        XCTAssertLessThanOrEqual(cacheDate!, afterCaching)
    }
    
    // MARK: - Test Cache Expiration
    func testCacheExpiration() async throws {
        try await cacheService.cacheWeatherData(mockWeatherResponse)
        let expiredDate = Date().addingTimeInterval(-400)
        UserDefaults.standard.set(expiredDate, forKey: "weather_cache_date")
        
        // When & Then
        do {
            _ = try await cacheService.getCachedWeatherData()
            XCTFail("Should have thrown cache not found error for expired cache")
        } catch CacheServiceError.cacheNotFound { } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Test Clear Cache
    func testClearCache() async throws {
        
        try await cacheService.cacheWeatherData(mockWeatherResponse)
        
        let cachedData = try await cacheService.getCachedWeatherData()
        XCTAssertNotNil(cachedData)
        
        try await cacheService.clearCache()
        
        
        do {
            _ = try await cacheService.getCachedWeatherData()
            XCTFail("Should have thrown cache not found error")
        } catch CacheServiceError.cacheNotFound {} catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        let cacheDate = await cacheService.getCacheDate()
        XCTAssertNil(cacheDate)
    }
    
    func testCacheNotFound() async {
        do {
            _ = try await cacheService.getCachedWeatherData()
            XCTFail("Should have thrown cache not found error")
        } catch CacheServiceError.cacheNotFound {
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Test Cache Date When No Cache
    func testCacheDateWhenNoCache() async {
        // Given - No cached data
        
        // When
        let cacheDate = await cacheService.getCacheDate()
        
        // Then
        XCTAssertNil(cacheDate)
    }
    
    // MARK: - Test Multiple Cache Operations
    func testMultipleCacheOperations() async throws {
        // Given
        let firstWeatherData = mockWeatherResponse!
        let secondWeatherData = createMockWeatherResponse(temperature: 65.0)
        
        // When - Cache first data
        try await cacheService.cacheWeatherData(firstWeatherData)
        let firstCached = try await cacheService.getCachedWeatherData()
        
        // Cache second data (should overwrite first)
        try await cacheService.cacheWeatherData(secondWeatherData)
        let secondCached = try await cacheService.getCachedWeatherData()
        
        // Then
        XCTAssertNotNil(firstCached)
        XCTAssertNotNil(secondCached)
        
        let firstTemp = firstCached?.data.timelines.first?.intervals.first?.values.temperature
        let secondTemp = secondCached?.data.timelines.first?.intervals.first?.values.temperature
        
        XCTAssertEqual(firstTemp, 56.98)
        XCTAssertEqual(secondTemp, 65.0)
    }
    
    // MARK: - Helper Methods
    private func createMockWeatherResponse(temperature: Double = 56.98) -> WeatherResponse {
        let weatherValues = WeatherValues(
            precipitationIntensity: 0.0083,
            precipitationType: 1,
            windSpeed: 3,
            windGust: 6.98,
            windDirection: 21,
            temperature: temperature,
            temperatureApparent: temperature - 1,
            cloudCover: 100,
            cloudBase: nil,
            cloudCeiling: nil,
            weatherCode: 4000
        )
        
        let interval = WeatherInterval(
            startTime: "2021-03-24T14:47:00-04:00",
            values: weatherValues
        )
        
        let timeline = Timeline(
            timestep: "1h",
            startTime: "2021-03-24T14:47:00-04:00",
            endTime: "2021-03-25T14:47:00-04:00",
            intervals: [interval]
        )
        
        let weatherData = WeatherData(timelines: [timeline])
        
        return WeatherResponse(data: weatherData, warnings: [])
    }
}

