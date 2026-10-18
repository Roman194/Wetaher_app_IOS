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
    public var isLoadingStarted: Bool = false
    
    public init(weatherRepo: WeatherRepository, initalValue: City = .moscow){
        weatherRepository = weatherRepo
        selectedCity = initalValue
        weatherUIState = .Loading
        
        Task{
            await loadWeather()
        }
        
    }
    
    private func loadWeather() async {
        
        guard !isLoadingStarted else { return }
        isLoadingStarted = true

            let weather = await weatherRepository.GetWeatherForSelectedCity(for: selectedCity)
            
            switch weather{
                case .success(let currentForecast) :
                weatherUIState = .Success(currentForecast.ToUI(city: selectedCity)) //Нужен ли здесь City?
                case .failure(let forecastError) :
                weatherUIState = .Fail(forecastError.ToUI())
            }
        
        isLoadingStarted = false
            
    }
    
    public func refreshWeather() async{
        weatherUIState = .Loading
        
        await loadWeather()
    }
    
    public func selectCity(newCity: City) async {
        guard newCity.id != selectedCity.id else { return } //Не очень понимаю как правильно читать guard
        self.selectedCity = newCity
        
        weatherUIState = .Loading

        await loadWeather()
    }
    
}
