//
//  WeatherDataRow.swift
//  DemoApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import SwiftUI

struct WeatherDataRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

struct WeatherDataRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherDataRow(icon: "thermometer", title: "Temperature", value: "25.3°C")
                .previewDisplayName("Normal Temperature")
                .previewLayout(.sizeThatFits)
                .padding()
            
            WeatherDataRow(icon: "wind", title: "Wind Speed", value: "15 mph")
                .previewDisplayName("Wind Speed")
                .previewLayout(.sizeThatFits)
                .padding()
            
            WeatherDataRow(icon: "cloud.rain.fill", title: "Rainfall", value: "2.0 mm")
                .previewDisplayName("Rainfall")
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
