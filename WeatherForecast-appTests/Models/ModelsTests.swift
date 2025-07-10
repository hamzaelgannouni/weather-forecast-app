//
//  ModelsTests.swift
//  weather-forecast-appTests
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import XCTest
@testable import WeatherForecastApp

final class ModelsTests: XCTestCase {
    func testDecodeLargeWeatherJSON() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "WeatherSample", withExtension: "json") else {
            XCTFail("Failed to find WeatherSample.json")
            return
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let response = try decoder.decode(WeatherResponse.self, from: data)
            XCTAssertFalse(response.data.timelines.isEmpty)
            XCTAssertNotNil(response.data.timelines.first?.intervals.first?.values.temperature)
            XCTAssertEqual(response.data.timelines.first?.intervals.first?.values.temperature, 56.98)
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }
}

