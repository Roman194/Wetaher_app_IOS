//
//  WeatherCondition.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 04.10.2026.
//

import Foundation
import SwiftUI

public struct WeatherCondition: Equatable, Hashable {
    let weatherCode: Int
    let description: String
    let sfSymbolName: String
    let iconColor: Color
    let backgroundColors: [Color]
    let timeZoneID: String
}

extension WeatherCondition{
    public static let weatherConditionsDict: [Int : WeatherCondition] = [:]
}
