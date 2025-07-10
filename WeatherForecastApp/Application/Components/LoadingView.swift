//
//  LoadingView.swift
//  DemoApp
//
//  Created by ELGANNOUNI Hamza on 10/7/2025.
//

import SwiftUI

struct LoadingView: View {
    let title: String
    init(title: String = "Loading weather data...") {
        self.title = title
    }
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    LoadingView()
}

