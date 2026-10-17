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
    
    func getCityLatLongByName(cityName: String) async -> Result<PossibleCitiesResponse, CityResponseError>{
        guard let url = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(cityName)&count=3&language=en&format=json")
        else {
            return .failure(CityResponseError(errorId: 13, errorDescription: "Ошибка конвертации URL-запроса"))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            let httpResponse = response as? HTTPURLResponse
            guard (200...299).contains(httpResponse!.statusCode)
            else{
                return .failure(CityResponseError(
                    errorId: httpResponse!.statusCode,
                    errorDescription: "Ошибка сервера: HTTP \(httpResponse!.statusCode)"
                ))
            }
            
            print(String(data: data, encoding: .utf8) ?? "No data")

            let cities = try JSONDecoder().decode(PossibleCitiesResponse.self, from: data)
            return .success(cities)
            } catch {
                return .failure(CityResponseError(errorId: 600, errorDescription: "\(error)"))
            }
    }
    
}
