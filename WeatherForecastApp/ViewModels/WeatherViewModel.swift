//
//  WeatherViewModel.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation
import Combine

// MARK: - Weather View Model
@MainActor
class WeatherViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var hourlyWeatherData: [HourlyWeatherData] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    @Published var isOffline = false
    @Published var lastUpdated: Date?
    
    // MARK: - Private Properties
    private let weatherService: WeatherServiceProtocol
    private let cacheService: WeatherCacheServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        weatherService: WeatherServiceProtocol = LocalWeatherService(),
         cacheService: WeatherCacheServiceProtocol = WeatherCacheService()
    ) {
        self.weatherService = weatherService
        self.cacheService = cacheService
        
        setupNetworkMonitoring()
        loadInitialData()
    }
    
    // MARK: - Private Methods
    private func setupNetworkMonitoring() {
        // For LocalWeatherService, we're always "online" since data comes from bundle
        if let weatherService = weatherService as? WeatherService {
            weatherService.$isNetworkAvailable
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isAvailable in
                    self?.isOffline = !isAvailable
                }
                .store(in: &cancellables)
        } else if let localService = weatherService as? LocalWeatherService {
            localService.$isNetworkAvailable
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isAvailable in
                    self?.isOffline = false // Local data is always available
                }
                .store(in: &cancellables)
        }
    }
    
    private func loadInitialData() {
        Task {
            await loadWeatherData()
        }
    }
    
    private func processWeatherResponse(_ response: WeatherResponse) {
        let hourlyTimeline = response.data.timelines.first { $0.timestep == "1h" }
        let intervals = hourlyTimeline?.intervals ?? []
        
        // Take only the next 24 hours
        let next24Hours = Array(intervals.prefix(24))
        
        self.hourlyWeatherData = next24Hours.map { $0.toHourlyWeatherData() }
        self.lastUpdated = Date()
    }
    
    private func handleError(_ error: Error) {
        switch error {
        case WeatherServiceError.networkUnavailable:
            self.errorMessage = "Network unavailable. Showing cached data."
            self.isOffline = true
        case WeatherServiceError.serverError(let code):
            self.errorMessage = "Server error (\(code)). Please try again later."
        case WeatherServiceError.decodingError:
            self.errorMessage = "Unable to process weather data."
        case CacheServiceError.cacheNotFound:
            self.errorMessage = "No cached data available. Please check your connection."
        default:
            self.errorMessage = error.localizedDescription
        }
        self.showingError = true
    }
    
    // MARK: - Public Methods
    func loadWeatherData() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        showingError = false
        
        do {
            // Try to fetch fresh data from API
            let weatherResponse = try await weatherService.fetchWeatherData()
            
            // Cache the successful response
            try await cacheService.cacheWeatherData(weatherResponse)
            
            // Process and update UI
            processWeatherResponse(weatherResponse)
            isOffline = false
            
        } catch {
            print("Failed to fetch weather data: \(error)")
            
            // Try to load cached data
            do {
                if let cachedResponse = try await cacheService.getCachedWeatherData() {
                    processWeatherResponse(cachedResponse)
                    
                    // Show offline message if network is unavailable
                    if case WeatherServiceError.networkUnavailable = error {
                        errorMessage = "Using cached data. Network unavailable."
                        showingError = true
                        isOffline = true
                    }
                } else {
                    handleError(error)
                }
            } catch {
                handleError(error)
            }
        }
        
        isLoading = false
    }
    
    func refreshWeatherData() async {
        await loadWeatherData()
    }
    
    func dismissError() {
        showingError = false
        errorMessage = nil
    }
    
    // MARK: - Computed Properties
    var currentWeather: HourlyWeatherData? {
        return hourlyWeatherData.first
    }
    
    var formattedLastUpdated: String {
        guard let lastUpdated = lastUpdated else {
            return "Never"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: lastUpdated)
    }
    
    var statusMessage: String {
        if isOffline {
            return "Offline - Using cached data"
        } else if isLoading {
            return "Updating..."
        } else {
            return "Last updated: \(formattedLastUpdated)"
        }
    }
}

// MARK: - Extensions
extension WeatherViewModel {
    static func preview() -> WeatherViewModel {
        let viewModel = WeatherViewModel(
            weatherService: LocalWeatherService(),
            cacheService: MockWeatherCacheService()
        )
        
        // Add some mock data for preview
        viewModel.hourlyWeatherData = [
            HourlyWeatherData(
                time: Date(),
                temperature: 56.98,
                temperatureApparent: 55.87,
                weatherCode: 4000,
                windSpeed: 3.0,
                precipitationIntensity: 0.0083,
                cloudCover: 100
            ),
            HourlyWeatherData(
                time: Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date(),
                temperature: 57.92,
                temperatureApparent: 57.97,
                weatherCode: 4000,
                windSpeed: 9.78,
                precipitationIntensity: 0.0161,
                cloudCover: 100
            )
        ]
        
        return viewModel
    }
}

