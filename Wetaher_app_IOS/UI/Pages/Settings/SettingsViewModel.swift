//
//  SettingsViewModel.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

import Observation
import SwiftUI

@MainActor
@Observable
public class SettingsViewModel {
    private let settingsRepository: SettingsRepository

    /// Тема приложения. Меняется только через `themeSelection`, чтобы выбор всегда сохранялся.
    public private(set) var appTheme: AppThemeProps

    /// Привязка для `Picker`. Запись идёт через неё, поэтому View не знает,
    /// как именно тема сохраняется: это ответственность ViewModel.
    public var themeSelection: Binding<AppThemeProps> {
        Binding(
            get: { self.appTheme },
            set: { self.selectTheme($0) }
        )
    }

    public init(settingsRepo: SettingsRepository) {
        self.settingsRepository = settingsRepo
        self.appTheme = AppThemeProps.from(id: settingsRepo.LoadThemeID())
    }

    /// Выбирает тему и сразу сохраняет её в `UserDefaults`.
    public func selectTheme(_ theme: AppThemeProps) {
        guard appTheme != theme else { return }

        appTheme = theme
        settingsRepository.SetTheme(id: theme.id)
    }
}
