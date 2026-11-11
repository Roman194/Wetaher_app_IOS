//
//  CityListViewModel.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

import Observation
import Foundation

@MainActor
@Observable
public class CityListViewModel {
    /// Избранные города храним как сущности, а в UI отдаём готовую проекцию.
    private var savedCityEntities: [CityEntity] = []
    public var savedCities: [City] {
        savedCityEntities.map { $0.toUI() }
    }
    public var savedCitiesWeather: [ForecastUI] = []
    public var savedCitiesWeatherError: [String: WeatherErrorUI] = [:]
    public var searchTask: Task<Void, Never>?
    /// Последние результаты поиска в виде сущностей: из них берём город при добавлении.
    private var searchResults: [CityEntity] = []

    public var cityListWeatherUIState: CityListUIState
    public var addCityUIState: AddCityUIState

    private let weatherRepository: WeatherRepository

    public init(weatherRepo: WeatherRepository) {
        self.weatherRepository = weatherRepo
        self.savedCityEntities = weatherRepo.LoadSavedCities()

        cityListWeatherUIState = .Loading
        addCityUIState = .Loading
    }

    public func loadSavedCitiesWeather(selectedCityForecast: ForecastUI) async {
        let selectedCity = selectedCityForecast.city

        var updatedList: [ForecastUI] = []
        savedCitiesWeatherError = [:]

        for city in savedCities { //Cюда прокидывается selectedCity, чтобы лишний раз не запрашивать уже запрошенный город
            if city.id == selectedCity.id {
                updatedList.append(selectedCityForecast)
            } else {
                let weather = await weatherRepository.GetWeatherForSelectedCity(for: city)

                switch weather {
                case .success(let snapshot):
                    updatedList.append(snapshot.entity.toUI())
                case .failure(let forecastError):
                    savedCitiesWeatherError[city.name] = forecastError.toUI()
                }
            }
        }

        self.savedCitiesWeather = updatedList
        if !updatedList.isEmpty {
            cityListWeatherUIState = .Success
        } else {
            cityListWeatherUIState = .Fail
        }

        addCityUIState = .Success([])
    }
    
    public func loadSavedCitiesWeatherWrapper(selectedCityForecast: ForecastUI) {
        Task {
            await loadSavedCitiesWeather(selectedCityForecast: selectedCityForecast)
        }
    }

    public func searchCities(query: String) {
        // Предлагаю разрешать п-лю искать и добавлять новые города только когда у нас менее 9 избранных!

        searchTask?.cancel()

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            // self.searchResults = []
//            if cityListWeatherUIState == .Search {
//                cityListWeatherUIState = savedCitiesWeather.isEmpty && !savedCities.isEmpty ? .Fail : .Success
//            }
            addCityUIState = .Success([])
            //return searchResults
            return
        }

        addCityUIState = .Search
        searchTask = Task {
            try? await Task.sleep(nanoseconds: BaseNumeral.searchDebounceDuration)
            guard !Task.isCancelled else { return }

            addCityUIState = .Loading

            let results = await weatherRepository.SearchCities(query: trimmed)
            //guard !Task.isCancelled else { return }
            switch(results){
            case .success(let possibleCities):
//                    self.searchResults = possibleCities.map({ cities in
//                        cities.toUI()
//                    })
                let entities = possibleCities.map { $0.toEntity() }
                searchResults = entities
                addCityUIState = .Success(entities.map { $0.toUI() })

            case .failure(let cityError): //Ошибка поиска прокидывается в AddCityView
                    //self.searchResults = cityError.reserveCities
                addCityUIState = .Fail(cityError.toUI())
            }
        }

        //return searchResults
    }

    /// Добавление города в избранное
    public func addCity(city: City) async {
        guard !isCitySaved(city: city) else { return }

        weatherRepository.AddFavoriteCity(city)
        savedCityEntities = weatherRepository.LoadSavedCities()

        // Подгружаем сводку погоды для добавленного города
        let weather = await weatherRepository.GetWeatherForSelectedCity(for: city)
        switch weather {
        case .success(let snapshot):
            savedCitiesWeather.append(snapshot.entity.toUI())
        case .failure(let forecastError):
            savedCitiesWeatherError[city.name] = forecastError.toUI()
        }
    }
    
    public func addCityWrapper(city: City) {
        Task {
            await addCity(city: city)
        }
    }

    /// Удаление города из избранного
    public func deleteCity(city: City) -> ForecastUI? {
        let storedCount = savedCityEntities.count
        weatherRepository.RemoveFavoriteCity(cityID: city.id)

        savedCityEntities = weatherRepository.LoadSavedCities()
        if savedCityEntities.count != storedCount { //Должен быть хотя бы 1 сохранённый город!
            savedCitiesWeather.removeAll { $0.city.id == city.id || ($0.city.name == city.name && $0.city.country == city.country) }
            savedCitiesWeatherError.removeValue(forKey: city.name)
        }
        //Возвращаем п-лю рандомный сохранённый город на случай, если был удалён SelectedCity
        return savedCitiesWeather.randomElement()
    }

    /// Проверка, добавлен ли уже город в список избранных
    public func isCitySaved(city: City) -> Bool {
        savedCityEntities.contains(where: { $0.name == city.name && $0.country == city.country })
    }

}
