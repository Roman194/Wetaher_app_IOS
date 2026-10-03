//
//  WeatherError.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 03.10.2026.
//

import SwiftUI

struct WeatherError: View {
    
    var weatherErrorUI: WeatherErrorUI
    
    init(weatherErrorUI: WeatherErrorUI) {
        self.weatherErrorUI = weatherErrorUI
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)

            Text(weatherErrorUI.errorDescription)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Повторить") {
//                            Task {
//                                await weatherVM.loadWeather()
//                            }
            }
            .buttonStyle(.bordered)
        }
    }
}
