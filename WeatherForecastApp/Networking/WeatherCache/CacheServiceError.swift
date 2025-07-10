//
//  CacheServiceError.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

enum CacheServiceError: LocalizedError {
    case encodingError
    case decodingError
    case fileSystemError
    case cacheNotFound
    
    var errorDescription: String? {
        switch self {
        case .encodingError:
            return "Failed to encode weather data"
        case .decodingError:
            return "Failed to decode cached weather data"
        case .fileSystemError:
            return "File system error occurred"
        case .cacheNotFound:
            return "No cached data found"
        }
    }
}
