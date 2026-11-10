//
//  BaseNumeral.swift
//  Wetaher_app_IOS
//
//  Created by Sergeev Sergey on 27.10.2026.
//

import CoreGraphics

/// Числовые константы интерфейса: отступы, интервалы, размеры, шрифты и прозрачность.
///
/// Интервалы приведены к общей шкале 4 / 8 / 12 / 16 / 20,
/// отступы — к 16 / 20 / 24, чтобы не подбирать значение под каждый элемент.
public enum BaseNumeral {
    // MARK: - Отступы
    /// Горизонтальный отступ содержимого от краёв экрана.
    public static let screenHorizontalPadding: CGFloat = 16
    /// Нижний отступ прокручиваемого содержимого.
    public static let screenBottomPadding: CGFloat = 24
    /// Внутренний отступ карточек и секций.
    public static let cardPadding: CGFloat = 12
    /// Внутренний отступ карточки ошибки.
    public static let errorCardPadding: CGFloat = 24
    /// Отступ плавающей кнопки от нижнего края.
    public static let bottomButtonPadding: CGFloat = 16
    /// Внутренний отступ круглой кнопки-иконки.
    public static let iconButtonPadding: CGFloat = 8
    /// Горизонтальный отступ верхней панели управления.
    public static let controlPanelHorizontalPadding: CGFloat = 20
    /// Вертикальный отступ строки списка.
    public static let listRowVerticalInset: CGFloat = 4
    /// Отрицательный отступ под крупной температурой.
    public static let currentTemperatureVerticalPadding: CGFloat = -8

    // MARK: - Интервалы
    /// Минимальный интервал: иконка и подпись, строки внутри карточки.
    public static let textSpacing: CGFloat = 4
    /// Малый интервал: элементы управления, строки списка.
    public static let smallSpacing: CGFloat = 8
    /// Базовый интервал: контейнеры, карточки, сетка.
    public static let defaultSpacing: CGFloat = 12
    /// Интервал между крупными секциями экрана.
    public static let sectionSpacing: CGFloat = 16
    /// Разреженный интервал: карусели и широкие HStack.
    public static let wideSpacing: CGFloat = 20

    // MARK: - Скругления
    public static let cardCornerRadius: CGFloat = 12
    public static let largeCardCornerRadius: CGFloat = 16

    // MARK: - Размеры
    public static let gridColumnCount = 2
    public static let metricCardMinHeight: CGFloat = 110
    /// Ширина текстовой колонки: день недели, температура.
    public static let columnWidth: CGFloat = 72
    /// Размер квадратных элементов управления и минимальная ширина колонок.
    public static let controlSize: CGFloat = 56
    /// Высота иконок в строках и каруселях.
    public static let iconHeight: CGFloat = 24

    // MARK: - Шрифты
    /// Название города на главном экране.
    public static let cityNameFontSize: CGFloat = 32
    /// Текущая температура на главном экране.
    public static let currentTemperatureFontSize: CGFloat = 84
    /// Температура в карточке города.
    public static let cityCardTemperatureFontSize: CGFloat = 38
    /// Иконка ошибки в карточке города.
    public static let errorIconFontSize: CGFloat = 28
    /// Иконка капли осадков.
    public static let precipitationIconFontSize: CGFloat = 8
    /// Подписи-подсказки: вероятность осадков, служебный текст.
    public static let captionFontSize: CGFloat = 12

    // MARK: - Анимации
    public static let backgroundAnimationDuration: Double = 0.35

    // MARK: - Тени
    public static let floatingButtonShadowRadius: CGFloat = 8
    public static let floatingButtonShadowY: CGFloat = 4
    public static let floatingButtonShadowOpacity: Double = 0.2

    // MARK: - Прозрачность
    public static let cardBackgroundOpacity: Double = 0.8
    public static let cardBackgroundStrongOpacity: Double = 0.85
    public static let dividerOpacity: Double = 0.4
    public static let dimmedIconOpacity: Double = 0.9

    // MARK: - Поиск
    public static let searchDebounceDuration: UInt64 = 300_000_000
}
