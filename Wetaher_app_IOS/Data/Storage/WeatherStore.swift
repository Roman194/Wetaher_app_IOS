//
//  WeatherStore.swift
//  Wetaher_app_IOS
//
//  Created by Sergeev Sergey on 27.10.2026.
//

import Foundation
import SwiftData

/// Хранение последнего успешного ответа сети по каждому городу.
@MainActor
public final class WeatherStore {
    /// Схема хранилища: город, прогноз и три дочерние таблицы прогноза.
    public static let schema = Schema([
        CityRecord.self,
        WeatherRecord.self,
        CurrentWeatherRecord.self,
        HourlyWeatherRecord.self,
        DailyWeatherRecord.self
    ])

    /// Общее хранилище. `nil`, если SwiftData недоступна: приложение продолжает
    /// работать без кэша, а не падает на старте.
    public static let shared: WeatherStore? = makeShared()

    /// Один долгоживущий контекст: операции чтения и записи идут
    /// последовательно на главном акторе.
    private let context: ModelContext

    public init(container: ModelContainer) {
        let context = ModelContext(container)
        context.autosaveEnabled = false
        self.context = context
    }

    /// Открывает хранилище и возвращает типизированную ошибку вместо падения.
    public static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        do {
            return try ModelContainer(for: schema, configurations: configuration)
        } catch {
            throw WeatherStoreError.containerUnavailable(underlying: "\(error)")
        }
    }

    /// Пытается открыть постоянное хранилище, затем — хранилище в памяти.
    /// Если не удалось ни то, ни другое, возвращает `nil`: кэш просто отключается.
    public static func makeShared() -> WeatherStore? {
        do {
            return WeatherStore(container: try makeContainer())
        } catch {
            #if DEBUG
            print("Не удалось открыть хранилище погоды: \(error)")
            #endif

            do {
                return WeatherStore(container: try makeContainer(inMemory: true))
            } catch {
                #if DEBUG
                print("Не удалось открыть хранилище погоды в памяти: \(error)")
                #endif
                return nil
            }
        }
    }

    /// Сохраняет снимок, заменяя предыдущий снимок этого города.
    public func save(_ entity: WeatherEntity) throws {
        do {
            if let existing = try fetchRecord(cityID: entity.cityID) {
                // Старые дочерние записи заменяются новыми и удаляются вручную:
                // каскадное правило срабатывает только при удалении родителя.
                let staleCurrent = existing.current
                let staleHourly = existing.hourly
                let staleDaily = existing.daily

                existing.apply(entity)
                existing.city?.apply(entity)

                if let staleCurrent {
                    context.delete(staleCurrent)
                }
                staleHourly.forEach(context.delete)
                staleDaily.forEach(context.delete)
            } else {
                let city = CityRecord(entity: entity)
                context.insert(city)
                context.insert(WeatherRecord(entity: entity, city: city))
            }

            try context.save()
        } catch {
            context.rollback()
            throw WeatherStorageError(
                errorCode: 701,
                errorDescription: "Не удалось сохранить данные о погоде: \(error.localizedDescription)"
            )
        }
    }

    public func fetch(cityID: Int) throws -> WeatherEntity? {
        do {
            guard let record = try fetchRecord(cityID: cityID) else { return nil }
            return record.weatherEntity
        } catch {
            throw WeatherStorageError(
                errorCode: 702,
                errorDescription: "Не удалось прочитать данные о погоде: \(error.localizedDescription)"
            )
        }
    }

    public func delete(cityID: Int) throws {
        do {
            guard let record = try fetchRecord(cityID: cityID) else { return }
            let city = record.city

            // Дочерние записи удаляем явно, чтобы каскад не зависел от порядка
            // удаления и от состояния обратных связей.
            let current = record.current
            let hourly = record.hourly
            let daily = record.daily

            context.delete(record)
            if let city {
                context.delete(city)
            }
            if let current {
                context.delete(current)
            }
            hourly.forEach(context.delete)
            daily.forEach(context.delete)

            try context.save()
        } catch {
            throw WeatherStorageError(
                errorCode: 703,
                errorDescription: "Не удалось удалить данные о погоде: \(error.localizedDescription)"
            )
        }
    }

    public func deleteAll() throws {
        do {
            try context.delete(model: WeatherRecord.self)
            try context.delete(model: CityRecord.self)
            try context.delete(model: CurrentWeatherRecord.self)
            try context.delete(model: HourlyWeatherRecord.self)
            try context.delete(model: DailyWeatherRecord.self)
            try context.save()
        } catch {
            throw WeatherStorageError(
                errorCode: 704,
                errorDescription: "Не удалось очистить хранилище погоды: \(error.localizedDescription)"
            )
        }
    }

    private func fetchRecord(cityID: Int) throws -> WeatherRecord? {
        var descriptor = FetchDescriptor<WeatherRecord>(
            predicate: #Predicate { $0.cityID == cityID }
        )
        descriptor.fetchLimit = 1

        return try context.fetch(descriptor).first
    }
}

private extension CityRecord {
    func apply(_ entity: WeatherEntity) {
        name = entity.cityName
        country = entity.country
        latitude = entity.latitude
        longitude = entity.longitude
        timezone = entity.timezone
    }
}

private extension WeatherRecord {
    /// Record → Entity. Дочерние таблицы разворачиваются в массивы по `sortIndex`.
    var weatherEntity: WeatherEntity {
        WeatherEntity(
            cityID: cityID,
            cityName: city?.name ?? "",
            country: city?.country ?? "",
            latitude: city?.latitude ?? 0,
            longitude: city?.longitude ?? 0,
            timezone: city?.timezone ?? "",
            savedAt: savedAt,
            current: current?.currentWeatherEntity ?? .empty,
            hourly: hourly
                .sorted { $0.sortIndex < $1.sortIndex }
                .map(\.hourlyWeatherEntity),
            daily: daily
                .sorted { $0.sortIndex < $1.sortIndex }
                .map(\.dailyWeatherEntity)
        )
    }
}

private extension CurrentWeatherEntity {
    /// Пустая текущая погода — на случай повреждённой записи.
    static let empty = CurrentWeatherEntity(
        time: "",
        temperature: 0,
        apparentTemperature: 0,
        weatherCode: 0,
        isDay: true,
        windSpeed: 0,
        windDirection: 0,
        windGusts: 0,
        relativeHumidity: 0,
        dewPoint: 0,
        pressureMsl: 0,
        visibility: 0
    )
}
