//
//  WeatherUIState.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 03.10.2026.
//

enum WeatherUIState{
    case Loading
    case Success(WeatherUI)
    case Fail(WeatherErrorUI)
}
