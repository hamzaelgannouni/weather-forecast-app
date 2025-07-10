//
//  OfflineStatusRow.swift
//  DemoApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import SwiftUI

struct OfflineStatusRow: View {
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
                .foregroundColor(.orange)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Offline Mode")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Showing cached weather data")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    OfflineStatusRow()
}
