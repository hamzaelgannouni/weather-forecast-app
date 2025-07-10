//
//  WeatherView.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import SwiftUI

struct WeatherView: View {
    let hourlyWeatherData: [HourlyWeatherData]
    let isOffline: Bool
    let statusMessage: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(hourlyWeatherData) { weather in
                    HourlyWeatherRow(weather: weather)
                }
                
                if !isOffline {
                    StatusSection(
                        statusMessage: statusMessage,
                        isOffline: isOffline
                    )
                    .listRowSeparator(.hidden)
                } else {
                    OfflineStatusRow()
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Hourly Weather")
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(
            hourlyWeatherData: [
                HourlyWeatherData(
                    time: Date(),
                    temperature: 68,
                    temperatureApparent: 70,
                    weatherCode: 1000,
                    windSpeed: 4.5,
                    precipitationIntensity: 0,
                    cloudCover: 0
                ),
                HourlyWeatherData(
                    time: Date().addingTimeInterval(3600),
                    temperature: 65,
                    temperatureApparent: 66,
                    weatherCode: 1101,
                    windSpeed: 6.2,
                    precipitationIntensity: 0,
                    cloudCover: 0.2
                )
            ],
            isOffline: false,
            statusMessage: "All data up to date"
        )
    }
}
