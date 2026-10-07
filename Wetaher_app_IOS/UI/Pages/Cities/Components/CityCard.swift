//
//  CityCard.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

import SwiftUI

/// Карточка города для списка избранного
public struct CityCard: View {
    public let forecast: ForecastUI

    public init(forecast: ForecastUI) {
        self.forecast = forecast
    }

    private var localTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let timeZone = TimeZone(identifier: forecast.city.timeZoneID) {
            formatter.timeZone = timeZone
        }
        return formatter.string(from: Date())
    }

    public var body: some View {
        let symbolName: String = {
            switch forecast.currentWeather.weatherCondition.sfSymbolName {
            case .same(let name):
                return name
            case .diff(let day, let night):
                return forecast.currentWeather.isDay ? day : night
            }
        }()
        let iconColor: Color = {
            switch forecast.currentWeather.weatherCondition.iconColor {
            case .same(let color):
                return color
            case .diff(let day, let night):
                return forecast.currentWeather.isDay ? day : night
            }
        }()

        HStack(alignment: .center) {
            // Левая часть: название города, страна, локальное время и погодные условия
            VStack(alignment: .leading, spacing: 3) {
                Text(forecast.city.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                Text("\(forecast.city.country) • \(localTime)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 6) {
                    Image(systemName: symbolName)
                        .foregroundStyle(iconColor)
                        .font(.caption)

                    Text(forecast.currentWeather.weatherCondition.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 4)
            }

            Spacer()

            // Правая часть: текущая температура и дневной диапазон (макс / мин)
            VStack(alignment: .trailing, spacing: 3) {
                Text(MetricFormatter.temperature(forecast.currentWeather.temperature, showSign: false))
                    .font(.system(size: 38, weight: .light, design: .rounded))
                    .foregroundStyle(.primary)

                if let today = forecast.dailyWeather.first {
                    Text("\(MetricFormatter.temperature(today.tempMax)) / \(MetricFormatter.temperature(today.tempMin))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(uiColor: .secondarySystemGroupedBackground).opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
