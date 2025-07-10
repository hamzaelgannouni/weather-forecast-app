//
//  WeatherCacheService.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation

class WeatherCacheService: WeatherCacheServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let fileManager = FileManager.default
    private let cacheFileName = "weather_cache.json"
    private let cacheDateKey = "weather_cache_date"
    private let cacheExpirationInterval: TimeInterval = 300 // 5 minutes
    
    private var cacheFileURL: URL? {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(cacheFileName)
    }
    
    func cacheWeatherData(_ data: WeatherResponse) async throws {
        guard let cacheURL = cacheFileURL else {
            throw CacheServiceError.fileSystemError
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodedData = try encoder.encode(data)
            
            try encodedData.write(to: cacheURL)
            
            // Store cache timestamp
            userDefaults.set(Date(), forKey: cacheDateKey)
            
        } catch {
            if error is EncodingError {
                throw CacheServiceError.encodingError
            } else {
                throw CacheServiceError.fileSystemError
            }
        }
    }
    
    func getCachedWeatherData() async throws -> WeatherResponse? {
        guard let cacheURL = cacheFileURL else {
            throw CacheServiceError.fileSystemError
        }
        
        guard fileManager.fileExists(atPath: cacheURL.path) else {
            throw CacheServiceError.cacheNotFound
        }
        
        // Check if cache is expired
        if await isCacheExpired() {
            try await clearCache()
            throw CacheServiceError.cacheNotFound
        }
        
        do {
            let data = try Data(contentsOf: cacheURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            
            return weatherResponse
            
        } catch {
            if error is DecodingError {
                throw CacheServiceError.decodingError
            } else {
                throw CacheServiceError.fileSystemError
            }
        }
    }
    
    func clearCache() async throws {
        guard let cacheURL = cacheFileURL else {
            throw CacheServiceError.fileSystemError
        }
        
        do {
            if fileManager.fileExists(atPath: cacheURL.path) {
                try fileManager.removeItem(at: cacheURL)
            }
            userDefaults.removeObject(forKey: cacheDateKey)
        } catch {
            throw CacheServiceError.fileSystemError
        }
    }
    
    func getCacheDate() async -> Date? {
        return userDefaults.object(forKey: cacheDateKey) as? Date
    }
    
    private func isCacheExpired() async -> Bool {
        guard let cacheDate = await getCacheDate() else {
            return true
        }
        
        return Date().timeIntervalSince(cacheDate) > cacheExpirationInterval
    }
}
