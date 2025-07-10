//
//  weather_forecast_appApp.swift
//  weather-forecast-app
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import SwiftUI

@main
struct weather_forecast_appApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
