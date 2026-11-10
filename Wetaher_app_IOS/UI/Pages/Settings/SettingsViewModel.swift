//
//  SettingsViewModel.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

import Observation

@MainActor
@Observable
public class SettingsViewModel {
    private let preferences: UserPreferencesStoring

    private let weatherRepository: WeatherRepository
    public var appTheme: AppThemeProps

    public init(weatherRepo: WeatherRepository, preferences: UserPreferencesStoring) {
        self.weatherRepository = weatherRepo
        self.preferences = preferences
        self.appTheme = AppThemeProps.from(id: preferences.themeID)
    }

    /// Выбирает тему и сразу сохраняет её в `UserDefaults`.
    public func selectTheme(_ theme: AppThemeProps) {
        guard appTheme != theme else { return }

        appTheme = theme
        preferences.themeID = theme.id
    }
}
