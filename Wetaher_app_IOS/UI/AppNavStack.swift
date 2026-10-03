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
                case .Success(let weatherUI): //TODO: Вынести Succes и Fail случаи в отдельные структуры?
                    VStack(spacing: 12) {
                        HStack {
                            Button {
                                showSettingsSheet = true
                            } label: {
                                Image(systemName: "gearshape")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                    .padding(8)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground).opacity(0.8))
                                    .clipShape(Circle())
                            }

                            Spacer()

                            Button {
                                showCityListSheet = true
                            } label: {
                                Image(systemName: "list.bullet")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                    .padding(8)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground).opacity(0.8))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                        
                        WeatherMainView()
                    }
                case .Fail(let weatherErrorUI):
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)

                        Text(weatherErrorUI.errorDescription)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button("Повторить") {
    //                            Task {
    //                                await weatherVM.loadWeather()
    //                            }
                        }
                        .buttonStyle(.bordered)
                    }
                
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
