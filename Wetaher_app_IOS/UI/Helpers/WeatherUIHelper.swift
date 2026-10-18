//
//  WeatherUIHelper.swift
//  Wetaher_app_IOS
//
//  Created by Sergey Sergeev on 07.10.2026.
//

import SwiftUI
//ВЫзывать во ViewModel и пропихнуть в UI-структуру!
/// Вспомогательные структуры и утилиты для презентации погоды в UI
public enum WeatherUIHelper {
    /// Определение текстового направления ветра по градусам (0-360)
    public static func degreesToDirection(_ degrees: Int) -> String {
        let directions = ["С", "СВ", "В", "ЮВ", "Ю", "ЮЗ", "З", "СЗ"]
        let normalized = ((degrees % 360) + 360) % 360
        let index = Int(round(Double(normalized) / 45.0)) % 8
        return directions[index]
    }

    /// Описание статуса УФ-индекса
    public static func uvStatus(for index: Double) -> UVStatus { //Color вообще используется хоть где-то?
        switch index {
        case ..<3.0:
            return UVStatus(descripiton: "Низкий", color: .green)
        case 3.0..<6.0:
            return UVStatus(descripiton: "Умеренный", color: .yellow)
        case 6.0..<8.0:
            return UVStatus(descripiton: "Высокий", color: .orange)
        case 8.0..<11.0:
            return UVStatus(descripiton: "Очень высокий", color: .red)
        default:
            return UVStatus(descripiton: "Экстремальный", color: .purple)
        }
    }

//    /// Цвет для значения УФ-индекса
//    public static func uvIndexColor(for index: Double) -> Color {
//        switch index {
//        case ..<3.0:
//            return .green
//        case 3.0..<6.0:
//            return .yellow
//        case 6.0..<8.0:
//            return .orange
//        case 8.0..<11.0:
//            return .red
//        default:
//            return .purple
//        }
//    }

    /// Описание статуса атмосферного давления
    public static func pressureStatus(for pressureHpa: Double) -> String {
        if pressureHpa >= 1010 && pressureHpa <= 1018 {
            return "Нормальное"
        } else if pressureHpa > 1018 {
            return "Повышенное"
        } else {
            return "Пониженное"
        }
    }
    
    /// Форматирование давления в миллиметрах ртутного столба (мм рт. ст.)
    public static func pressureMmHg(_ hPa: Double) -> Int {
        return Int(round(hPa * 0.750062))
    }
    
    /// Форматирование видимости в километрах
    public static func visibility(_ metersOrKm: Double) -> Double {
        let km = metersOrKm >= 1000 ? metersOrKm / 1000.0 : metersOrKm
        return round(km)
    }

    /// Описание статуса видимости
    public static func visibilityStatus(for km: Double) -> String {
        return km >= 10.0 ? "Отличная" : "Ограниченная"
    }

    /// Извлечение времени "ЧЧ:мм" из строки формата "YYYY-MM-DDTHH:mm"
    public static func formatTimeString(_ dateString: String) -> String {
        if let tIndex = dateString.firstIndex(of: "T") {
            let timeSubstring = dateString[dateString.index(after: tIndex)...]
            return String(timeSubstring.prefix(5))
        }
        return dateString
    }
    
    /// Извлечение даты "YYYY-MM-DD" из строки формата "YYYY-MM-DDTHH:mm"
    public static func formatDayString(_ dayString: String) -> String {
        if let tIndex = dayString.firstIndex(of: "T") {
            return String(dayString[..<tIndex])
        }
        return dayString
    }

    /// Форматирование даты в локализованный вид "d MMM" (например, "4 окт")
    public static func formatDateString(_ dateString: String) -> String {
        let datePart = dateString.components(separatedBy: "T").first ?? dateString
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .gmt //Время по гринвичу!
        if let date = formatter.date(from: datePart) {
            let displayFormatter = DateFormatter()
            displayFormatter.locale = Locale(identifier: "ru_RU")
            displayFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            displayFormatter.dateFormat = "d MMM"
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}
