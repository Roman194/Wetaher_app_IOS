//
//  WeatherRepositoryImpl.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//
import Foundation

public class WeatherRepositoryImpl: WeatherRepository{
    private var currentForecast: ForecastUI
    private var networkClient: NetworkClient
    private var checker: Bool
    
    public init(currentWeather: ForecastUI = .moskowWeather, networkClient: NetworkClient = NetworkClient()) {
        self.currentForecast = currentWeather
        self.networkClient = networkClient
        checker = true
    }
    
    public func GetWeatherForSelectedCity(for city: City) async -> Result<ForecastUI, WeatherErrorUI>{
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        currentForecast =
            switch city{
                case .moscow : .moskowWeather
                case .saintPetersburg : .saintPetersburgWeather
                case .kazan : .kazanWeather
                case .krasnoyarsk : .krasnoyarskWeather
                case .nizhnyNovgorod : .nizhnyNovgorodWeather
                case .novosibirsk : .novosibirskWeather
                case .kaliningrad : .kaliningradWeather
                case .samara : .samaraWeather
                case .vladivostok : .vladivostokWeather
                case .yekaterinburg : .yekaterinburgWeather
                case .malmo : .malmoWeather
                case .hong_Kong : .hongKongWeather
                default : .moskowWeather
            }
        
        if (checker == true){
//            networkClient.getCityWeather(latitude: "52.52", longitude: "13.41", weatherResponse: { weather in
//                print(String(weather?.current.dewPoint2m  ?? 11.2))
//            })
            
//            let response = await networkClient.getCityLatLongByName(cityName: "Berlin") //trimmed
//            
//            switch(response){
//                case .success(let possibleCities):
//                    print(possibleCities.results.first?.name)
//                case .failure(var cityError):
//                    print(String(cityError.errorId))
//            
//            }
            
            
            checker = false
        }
        
        if Int.random(in: 1...10) % 2 == 0{
            return .success(currentForecast)
        }
        else{
            return .failure(WeatherErrorUI(errorCode: 67 , errorDescription: "Trial error exception"))
        }
        
    }
    
    public func LoadFavoriteCities() -> [City] {
        return City.defaultFavorites
    }
    
    public func SearchCities(query: String) async -> Result<[CityResponse], CityResponseError> {
        var trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmed.isEmpty { return .failure(CityResponseError(errorId: 10, errorDescription: "Не введено значение для поиска города")) }
        
        let isOnlyLatinCharacters = trimmed.range(of: "\\P{Latin}", options: .regularExpression) == nil
        let isOnlyCyrillicCharacters = trimmed.range(of: "\\P{Cyrillic}", options: .regularExpression) == nil
        
        if (isOnlyLatinCharacters || isOnlyCyrillicCharacters){
            //Do some stuff
            if(isOnlyCyrillicCharacters){
                trimmed = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                
                guard trimmed != "" else {return .failure(CityResponseError(errorId: 11, errorDescription: "Не получается конверитровать символы кириллицы"))}
            }
            
            let response = await networkClient.getCityLatLongByName(cityName: trimmed) //"Berlin"
            
            switch(response){
                case .success(let possibleCities):
                    return .success(possibleCities.results)
                case .failure(var cityError):
                    if((400...599).contains(cityError.errorId)){
                        cityError.reserveCities = cityError.reserveCities.filter { city in
                                        city.name.lowercased().contains(trimmed) ||
                                        city.country.lowercased().contains(trimmed)
                                    }
                    }
                
                return .failure(cityError)
            
            }
            
            
        }else{
            return .failure(CityResponseError(errorId: 12, errorDescription: "В строке содержатся недопустимы символы или смешано кириллическое и латинское написания"))
        }
    }
}
