//
//  WeatherUI.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 03.10.2026.
//
import Foundation

public struct WeatherUI: Equatable, Hashable {
    let id: Int //А надо ли чтобы был ID?
    let currentWeather: CurrentWeather
    let hourlyWeather: HourlyWeather
    let dailyWeather: DailyWeather
}
