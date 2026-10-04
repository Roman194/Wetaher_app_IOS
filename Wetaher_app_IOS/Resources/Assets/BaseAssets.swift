//
//  BaseAssets.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

extension City {
    public static let moscow = City(
        id: 10,
        name: "Москва",
        country: "Россия",
        latitude: 55.752,
        longitude: 37.618,
        timeZoneID: "Europe/Moscow"
    )

    public static let saintPetersburg = City(
        id: 20,
        name: "Санкт-Петербург",
        country: "Россия",
        latitude: 59.939,
        longitude: 30.314,
        timeZoneID: "Europe/Moscow"
    )

    public static let kazan = City(
        id: 30,
        name: "Казань",
        country: "Россия",
        latitude: 55.7887,
        longitude: 49.1221,
        timeZoneID: "Europe/Moscow"
    )

    public static let yekaterinburg = City(
        id: 40,
        name: "Екатеринбург",
        country: "Россия",
        latitude: 56.8389,
        longitude: 60.6057,
        timeZoneID: "Asia/Yekaterinburg"
    )

    public static let novosibirsk = City(
        id: 50,
        name: "Новосибирск",
        country: "Россия",
        latitude: 55.0084,
        longitude: 82.9357,
        timeZoneID: "Asia/Novosibirsk"
    )

    public static let nizhnyNovgorod = City(
        id: 60,
        name: "Нижний Новгород",
        country: "Россия",
        latitude: 56.3269,
        longitude: 44.0059,
        timeZoneID: "Europe/Moscow"
    )

    public static let samara = City(
        id: 70,
        name: "Самара",
        country: "Россия",
        latitude: 53.1959,
        longitude: 50.1002,
        timeZoneID: "Europe/Samara"
    )

    public static let vladivostok = City(
        id: 80,
        name: "Владивосток",
        country: "Россия",
        latitude: 43.1198,
        longitude: 131.8869,
        timeZoneID: "Asia/Vladivostok"
    )

    public static let kaliningrad = City(
        id: 90,
        name: "Калининград",
        country: "Россия",
        latitude: 54.7104,
        longitude: 20.4522,
        timeZoneID: "Europe/Kaliningrad"
    )

    public static let krasnoyarsk = City(
        id: 100,
        name: "Красноярск",
        country: "Россия",
        latitude: 56.0153,
        longitude: 92.8932,
        timeZoneID: "Asia/Krasnoyarsk"
    )
    
    public static let Tromso = City(
        id: 110,
        name: "Мальмё",
        country: "Швеция",
        latitude: 55.605,
        longitude: 13.000,
        timeZoneID: "Europe/Stockholm"
    )
    
    public static let Hong_Kong = City(
        id: 120,
        name: "Гонконг",
        country: "HK",
        latitude: 22.278,
        longitude: 114.174,
        timeZoneID: "Asia/Hong_Kong"
    )

    /// Список городов по умолчанию для избранного
    public static let defaultFavorites: [City] = [
        .moscow,
        .saintPetersburg
    ]
}
