//
//  LocalWeatherServiceTests.swift
//  WeatherForecastAppTests
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import XCTest
@testable import WeatherForecastApp

class LocalWeatherServiceTests: XCTestCase {
    
    var localWeatherService: LocalWeatherService!
    
    override func setUp() {
        super.setUp()
        localWeatherService = LocalWeatherService()
    }
    
    override func tearDown() {
        localWeatherService = nil
        super.tearDown()
    }
    
    // MARK: - Test Local JSON Loading
    func testFetchWeatherDataFromLocalJSON() async throws {
        // When
        let weatherResponse = try await localWeatherService.fetchWeatherData()
        
        // Then
        XCTAssertNotNil(weatherResponse)
        XCTAssertFalse(weatherResponse.data.timelines.isEmpty)
        
        // Verify we have hourly data
        let hourlyTimeline = weatherResponse.data.timelines.first { $0.timestep == "1h" }
        XCTAssertNotNil(hourlyTimeline, "Should have 1h timestep timeline")
        XCTAssertFalse(hourlyTimeline?.intervals.isEmpty ?? true, "Should have intervals")
        
        // Verify the first interval has required data
        if let firstInterval = hourlyTimeline?.intervals.first {
            XCTAssertGreaterThan(firstInterval.values.temperature, 0, "Should have valid temperature")
            XCTAssertGreaterThan(firstInterval.values.temperatureApparent, 0, "Should have valid apparent temperature")
            XCTAssertGreaterThanOrEqual(firstInterval.values.windSpeed, 0, "Should have valid wind speed")
            XCTAssertNotNil(firstInterval.values.weatherCode, "Should have weather code")
        } else {
            XCTFail("Should have at least one interval")
        }
    }
    
    
   
}

