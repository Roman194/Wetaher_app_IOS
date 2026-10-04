//
//  WeatherRepository.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

public protocol WeatherRepository{
    func GetWeatherForSelectedCity(for city: City) async -> Result<ForecastUI, WeatherErrorUI>
}
