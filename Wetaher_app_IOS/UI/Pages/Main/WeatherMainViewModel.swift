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
        
        Task{
            await loadWeather()
        }
        
    }
    
    public func loadWeather() async {
        
        if case .Loading = weatherUIState {
            return
        }
        weatherUIState = .Loading

        //Пока что нет throws  в репо? поэтому кэтч не нужен. Если в будущем потребуется, то раскоментим
        //do { try
            let weather = await weatherRepository.GetWeatherForSelectedCity(for: selectedCity)
            
            switch weather{
            case .success(let currentForecast) :
                weatherUIState = .Success(currentForecast)
            case .failure(let forecastError) :
                weatherUIState = .Fail(forecastError)
            }
            

//        } catch {
//            weatherUIState = .Fail(<#T##WeatherErrorUI#>)
//        }
    }
    
    
    
}
