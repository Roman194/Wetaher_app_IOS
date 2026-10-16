//
//  NetworkClient.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 15.10.2026.
//
import Foundation

public class NetworkClient{
    
    public init (){
        
    }
    
    func getCityWeather(latitude: String, longitude: String, weatherResponse: @escaping (WeatherResponse?) -> Void){
        
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,weather_code,is_day,precipitation_probability&current=temperature_2m,apparent_temperature,weather_code,is_day,wind_speed_10m,wind_direction_10m,wind_gusts_10m,relative_humidity_2m,dew_point_2m,pressure_msl,visibility&daily=temperature_2m_max,temperature_2m_min,weather_code,uv_index_max,sunrise,sunset,precipitation_probability_mean") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){data, _, error in
            guard let data = data, error == nil else{
                weatherResponse(nil)
                return
            }
            
            //print(String(data: data, encoding: .utf8) ?? "No data")
            
            do{
                let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let weather = try decoder.decode(WeatherResponse.self, from: data)
                
                weatherResponse(weather)
            } catch{
                print("Ошибка: \(error)")
                weatherResponse(nil)
            }
        }.resume()
    }
    
    
    
    
    
    
}
