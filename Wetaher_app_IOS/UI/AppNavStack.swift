//
//  AppNavStack.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 03.10.2026.
//
import SwiftUI

struct AppNavStack: View{
    
    private let weatherRepo: WeatherRepository
    
    @State private var weatherVM = WeatherMainViewModel()//Передать репо
    @State private var cityListVM = CityListViewModel()
    @State private var settingsVM = SettingsViewModel()
    
    @State private var showCityListSheet = false
    @State private var showSettingsSheet = false
    
    @State private var weatherUIState: WeatherUIState
    
    public init(weatherRepository: WeatherRepository) {
        weatherRepo = weatherRepository
        weatherUIState = .Loading
    }
    
    var body: some View{
        ZStack{
            WeatherBackground()
            
            switch weatherUIState {
                case .Loading:
                    ProgressView()
                case .Success(let weatherUI):
                    WeatherSuccess(
                        showSettingsSheet: $showSettingsSheet,
                        showCityListSheet: $showCityListSheet
                    )
                case .Fail(let weatherErrorUI):
                    WeatherError(weatherErrorUI: weatherErrorUI)
                
            }
        }
        .sheet(isPresented: $showCityListSheet) {
            CityListView(cityListViewModel: cityListVM)
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView(settingsViewModel: settingsVM)
        }
    }
}
