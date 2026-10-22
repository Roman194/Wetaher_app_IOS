//
//  WeatherMainTestsUI.swift
//  Wetaher_app_IOSTestsUI
//

import XCTest
@testable import Wetaher_app_IOS

final class WeatherMainTestsUI: XCTestCase {

    /// Проверка отображения детальной информации о текущей погоде
    func testMainScreenDisplaysCurrentWeatherDetails() throws {
        // arrange
        let app = XCUIApplication()
        app.launch()
        let cityTitle = app.staticTexts[AccessibilityIdentifiers.Main.cityTitle]
        let conditionLabel = app.staticTexts[AccessibilityIdentifiers.Main.condition]
        let temperatureLabel = app.staticTexts[AccessibilityIdentifiers.Main.temperature]
        let feelsLikeLabel = app.staticTexts[AccessibilityIdentifiers.Main.feelsLike]

        // act
        let loaded = cityTitle.waitForExistence(timeout: 5.0)

        // assert
        XCTAssertTrue(loaded, "Главный экран должен успешно загрузиться")
        XCTAssertTrue(conditionLabel.exists, "Описание погодных условий должно отображаться")
        XCTAssertTrue(temperatureLabel.exists, "Температура должна отображаться")
        XCTAssertTrue(feelsLikeLabel.exists, "Блок 'Ощущается как' должен присутствовать")
    }

    /// Проверка наличия карточек метрик погоды в сетке показателей
    func testWeatherMetricsGridElementsExist() throws {
        // arrange
        let app = XCUIApplication()
        app.launch()
        let cityTitle = app.staticTexts[AccessibilityIdentifiers.Main.cityTitle]
        let windCard = app.otherElements[AccessibilityIdentifiers.Metrics.wind]
        let pressureCard = app.otherElements[AccessibilityIdentifiers.Metrics.pressure]
        let humidityCard = app.otherElements[AccessibilityIdentifiers.Metrics.humidity]
        let uvCard = app.otherElements[AccessibilityIdentifiers.Metrics.uv]

        // act
        _ = cityTitle.waitForExistence(timeout: 5.0)
        app.swipeUp()

        // assert
        XCTAssertTrue(windCard.waitForExistence(timeout: 5.0), "Карточка ветра должна отображаться в сетке")
        XCTAssertTrue(pressureCard.exists, "Карточка давления должна присутствовать")
        XCTAssertTrue(humidityCard.exists, "Карточка влажности должна присутствовать")
        XCTAssertTrue(uvCard.exists, "Карточка UV-индекса должна присутствовать")
    }

    /// Проверка обновления данных через Pull-To-Refresh
    func testPullToRefreshOnMainScreen() throws {
        // arrange
        let app = XCUIApplication()
        app.launch()
        let cityTitle = app.staticTexts[AccessibilityIdentifiers.Main.cityTitle]
        _ = cityTitle.waitForExistence(timeout: 5.0)
        let mainScrollView = app.scrollViews[AccessibilityIdentifiers.Main.scrollView]

        // act
        let startCoordinate = mainScrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        let endCoordinate = mainScrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        startCoordinate.press(forDuration: 0.1, thenDragTo: endCoordinate)

        // assert
        XCTAssertTrue(cityTitle.waitForExistence(timeout: 5.0), "Данные погоды должны оставаться доступными после pull-to-refresh")
    }
}
