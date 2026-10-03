//
//  CityListViewModel.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

import Observation

@MainActor
@Observable
public class CityListViewModel{
    private let weatherRepository: WeatherRepository
    
    public init(weatherRepo: WeatherRepository){
        weatherRepository = weatherRepo
    }
}
