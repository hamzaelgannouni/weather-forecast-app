//
//  StatusSection.swift
//  DemoApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import SwiftUI

struct StatusSection: View {
    let statusMessage: String
    let isOffline: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isOffline ? "wifi.slash" : "checkmark.circle.fill")
                .foregroundColor(isOffline ? .orange : .green)
            
            Text(statusMessage)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}


struct StatusSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatusSection(statusMessage: "Connected", isOffline: false)
                .previewDisplayName("Online")
                .previewLayout(.sizeThatFits)
                .padding()
            
            StatusSection(statusMessage: "No network connection", isOffline: true)
                .previewDisplayName("Offline")
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}

