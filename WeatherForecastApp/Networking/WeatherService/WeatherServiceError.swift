//
//  WeatherServiceError.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

enum WeatherServiceError: LocalizedError {
    case invalidURL
    case networkUnavailable
    case decodingError
    case serverError(Int)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .networkUnavailable:
            return "Network connection unavailable"
        case .decodingError:
            return "Unable to decode weather data"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}
