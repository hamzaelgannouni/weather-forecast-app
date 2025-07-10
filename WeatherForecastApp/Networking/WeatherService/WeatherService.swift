//
//  WeatherService.swift
//  WeatherForecastApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import Foundation
import Network

class WeatherService: WeatherServiceProtocol, ObservableObject {
    private let baseURL = "http://localhost:3000"
    private let session: URLSession
    private let networkMonitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "NetworkMonitor")
    
    @MainActor @Published var isNetworkAvailable = true
    
    init(session: URLSession = .shared) {
        self.session = session
        setupNetworkMonitoring()
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isNetworkAvailable = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: networkQueue)
    }
    
    func fetchWeatherData() async throws -> WeatherResponse {
        guard let url = URL(string: "\(baseURL)/weather") else {
            throw WeatherServiceError.invalidURL
        }
        
        let networkAvailable = await MainActor.run { isNetworkAvailable }
        guard networkAvailable else {
            throw WeatherServiceError.networkUnavailable
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10.0
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherServiceError.unknownError
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw WeatherServiceError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            
            return weatherResponse
            
        } catch DecodingError.dataCorrupted(_),
                DecodingError.keyNotFound(_, _),
                DecodingError.valueNotFound(_, _),
                DecodingError.typeMismatch(_, _) {
            throw WeatherServiceError.decodingError
        } catch let error as WeatherServiceError {
            throw error
        } catch {
            if error.localizedDescription.contains("network") {
                throw WeatherServiceError.networkUnavailable
            }
            throw WeatherServiceError.unknownError
        }
    }
    
    deinit {
        networkMonitor.cancel()
    }
}
