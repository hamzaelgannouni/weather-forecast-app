//
//  WeatherView.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.hourlyWeatherData) { weather in
                    HourlyWeatherRow(weather: weather)
                }
                
                if !viewModel.isOffline {
                    StatusSection(
                        statusMessage: viewModel.statusMessage,
                        isOffline: viewModel.isOffline
                    )
                    .listRowSeparator(.hidden)
                } else {
                    OfflineStatusRow()
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Hourly Weather")
            .refreshable {
                await refreshWeatherData()
            }
            .overlay(
                Group {
                    if viewModel.isLoading && viewModel.hourlyWeatherData.isEmpty {
                        LoadingView()
                    }
                }
            )
            .alert("Weather Alert", isPresented: $viewModel.showingError) {
                Button("OK") {
                    viewModel.dismissError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error occurred")
            }
        }
        .task {
            await viewModel.loadWeatherData()
        }
    }
    
    private func refreshWeatherData() async {
        isRefreshing = true
        await viewModel.refreshWeatherData()
        isRefreshing = false
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
            .preferredColorScheme(.light)
        
        WeatherView()
            .preferredColorScheme(.dark)
    }
}
