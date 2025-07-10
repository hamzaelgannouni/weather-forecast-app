//
//  LocalWeatherService.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

// MARK: - Local Weather Service
class LocalWeatherService: WeatherServiceProtocol, ObservableObject {
    @MainActor @Published var isNetworkAvailable = true
    
    func fetchWeatherData() async throws -> WeatherResponse {
        guard let url = Bundle.main.url(forResource: "weather_mockoon", withExtension: "json") else {
            throw WeatherServiceError.invalidURL
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            // Parse the Mockoon format to extract the actual weather data
            let mockoonResponse = try JSONDecoder().decode(MockoonResponse.self, from: data)
            
            // Extract the weather data from the first route's response body
            guard let firstRoute = mockoonResponse.routes.first,
                  let firstResponse = firstRoute.responses.first else {
                throw WeatherServiceError.decodingError
            }
            
            // Parse the embedded JSON string in the body
            guard let bodyData = firstResponse.body.data(using: .utf8) else {
                throw WeatherServiceError.decodingError
            }
            
            let decoder = JSONDecoder()
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: bodyData)
            
            // Simulate network delay for realistic behavior
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            return weatherResponse
            
        } catch DecodingError.dataCorrupted(_),
                DecodingError.keyNotFound(_, _),
                DecodingError.valueNotFound(_, _),
                DecodingError.typeMismatch(_, _) {
            throw WeatherServiceError.decodingError
        } catch {
            throw WeatherServiceError.unknownError
        }
    }
}

// MARK: - Mockoon Response Structure
private struct MockoonResponse: Codable {
    let routes: [MockoonRoute]
}

private struct MockoonRoute: Codable {
    let responses: [MockoonRouteResponse]
}

private struct MockoonRouteResponse: Codable {
    let body: String
}
