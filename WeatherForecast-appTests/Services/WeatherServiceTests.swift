//
//  WeatherServiceRealNetworkTests.swift
//  weather-forecast-appTests
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import XCTest
@testable import WeatherForecastApp

final class WeatherServiceTests: XCTestCase {
    
    var weatherService: WeatherService!
    
    override func setUp() {
        super.setUp()
        // Use the real URLSession here
        weatherService = WeatherService(session: URLSession.shared)
    }
    
    override func tearDown() {
        weatherService = nil
        super.tearDown()
    }
    
    func testFetchWeatherDataRealAPI() async throws {
        // Ensure network is assumed available (or test your isNetworkAvailable logic separately)
        await MainActor.run {
            weatherService.isNetworkAvailable = true
        }
        
        do {
            let response = try await weatherService.fetchWeatherData()
            
            // Assertions based on what you expect from the real API
            XCTAssertFalse(response.data.timelines.isEmpty, "Timelines should not be empty")
            XCTAssertNotNil(response.data.timelines.first?.intervals.first?.values.temperature, "Temperature should be present")
            
        } catch {
            XCTFail("API call failed with error: \(error)")
        }
    }
}
