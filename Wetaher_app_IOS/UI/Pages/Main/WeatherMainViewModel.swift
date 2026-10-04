//
//  WeatherMainViewModel.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//
import Observation

@MainActor
@Observable
public class WeatherMainViewModel{
    private let weatherRepository: WeatherRepository
    
    public var selectedCity: City
    public var weatherUIState: WeatherUIState
    
    public init(weatherRepo: WeatherRepository, initalValue: City = .moscow){
        weatherRepository = weatherRepo
        selectedCity = initalValue
        weatherUIState = .Loading
        
        loadWeather()
    }
    
    public func loadWeather() async {
        
        if case .Loading = weatherUIState {
            return
        }
        weatherUIState = .Loading

        do {
            let weather = try await weatherService.fetchWeather(for: selectedCity)
            self.currentWeather = weather
            weatherUIState = .Success(<#T##WeatherUI#>)

        } catch {
            weatherUIState = .Fail(<#T##WeatherErrorUI#>)
        }
    }
}
