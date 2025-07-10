//
//  HourlyWeatherRow.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import SwiftUI

struct HourlyWeatherRow: View {
    let weather: HourlyWeatherData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(weather.formattedTime)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: weather.weatherIcon)
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                WeatherDataRow(
                    icon: "thermometer",
                    title: "Temperature",
                    value: String(format: "%.1f°F", weather.temperature)
                )
                
                WeatherDataRow(
                    icon: "thermometer.medium",
                    title: "Feels-like Temperature",
                    value: String(format: "%.1f°F", weather.temperatureApparent)
                )
                
                WeatherDataRow(
                    icon: "wind",
                    title: "Wind Speed",
                    value: String(format: "%.1f mph", weather.windSpeed)
                )
            }
        }
        .padding(.vertical, 8)
    }
}

import SwiftUI

struct HourlyWeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HourlyWeatherRow(weather: mockWeatherData)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Sample Weather Row")
        }
    }
    
    static var mockWeatherData: HourlyWeatherData {
        HourlyWeatherData(
            time: Date(),
            temperature: 72.5,
            temperatureApparent: 75.0,
            weatherCode: 1000,
            windSpeed: 5.3,
            precipitationIntensity: 0.0,
            cloudCover: 0.1
        )
    }
}

