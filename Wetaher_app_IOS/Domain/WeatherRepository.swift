//
//  WeatherRepository.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

@MainActor
public protocol WeatherRepository {
    /// Возвращает актуальные данные из сети или последний сохранённый снимок из БД.
    func GetWeatherForSelectedCity(for city: City) async -> Result<WeatherSnapshot, WeatherErrorResponse>

    func LoadFavoriteCities() -> [CityEntity]

    func SearchCities(query: String) async -> Result<[CityResponse], CityResponseError>

    /// Сохранённые избранные города. При первом запуске список заполняется городами по умолчанию.
    func LoadSavedCities() -> [CityEntity]

    /// Добавляет город в избранное. Повторное добавление игнорируется.
    func AddFavoriteCity(_ city: City)

    /// Удаляет город из избранного и очищает его прогноз в БД.
    /// Город не удаляется, если он последний.
    func RemoveFavoriteCity(cityID: Int)

    /// Идентификатор последнего просмотренного города.
    func LoadActiveCityID() -> Int?

    /// Запоминает последний просмотренный город.
    func SetActiveCity(_ cityID: Int)
}
