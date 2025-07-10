//
//  WeatherView.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//


import Foundation

struct HourlyWeatherData: Identifiable {
    let id = UUID()
    let time: Date
    let temperature: Double
    let temperatureApparent: Double
    let weatherCode: Int
    let windSpeed: Double
    let precipitationIntensity: Double
    let cloudCover: Double
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: time)
    }
    
    var temperatureString: String {
        return String(format: "%.0f°", temperature)
    }
    
    var weatherCondition: String {
        switch weatherCode {
        case 1000: return "Clear"
        case 1100: return "Mostly Clear"
        case 1101: return "Partly Cloudy"
        case 1102: return "Mostly Cloudy"
        case 2000: return "Fog"
        case 4000: return "Drizzle"
        case 4001: return "Rain"
        case 4200: return "Light Rain"
        default: return "Unknown"
        }
    }
    
    var weatherIcon: String {
        switch weatherCode {
        case 1000: return "sun.max.fill"
        case 1100: return "sun.max.fill"
        case 1101: return "cloud.sun.fill"
        case 1102: return "cloud.fill"
        case 2000: return "cloud.fog.fill"
        case 4000, 4001, 4200: return "cloud.rain.fill"
        default: return "questionmark.circle.fill"
        }
    }
}

// MARK: - Extensions
extension WeatherInterval {
    var date: Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: startTime) ?? Date()
    }
    
    func toHourlyWeatherData() -> HourlyWeatherData {
        HourlyWeatherData(
            time: date,
            temperature: values.temperature,
            temperatureApparent: values.temperatureApparent,
            weatherCode: values.weatherCode,
            windSpeed: values.windSpeed,
            precipitationIntensity: values.precipitationIntensity ?? 0.0,
            cloudCover: values.cloudCover ?? 0.0
        )
    }
}
