//
//  WeatherRepositoryImpl.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

public class WeatherRepositoryImpl: WeatherRepository{
    public func GetWeatherForSelectedCity(for city: City) async -> Result<WeatherUI, WeatherErrorUI>{
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if Int.random(in: 1...10) % 2 == 0{
            return .success(WeatherUI(id: <#T##Int#>, currentWeather: <#T##CurrentWeather#>, hourlyWeather: <#T##HourlyWeather#>, dailyWeather: <#T##DailyWeather#>))
        }
        else{
            return .failure(WeatherErrorUI(errorCode: 67 , errorDescription: "Trial error exception"))
        }
        
    }
}
