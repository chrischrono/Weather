//
//  Forecast.swift
//  Weather
//
//  Created by Christian on 21/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation

struct ForecastResponse: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: Forecast
}


struct Forecast: Codable {
    let time: Double
    let summary: String?
    let icon: String?
    let precipIntensity: Float?
    let precipProbability: Float?
    let temperature: Float?
    let apparentTemperature: Float?
    let dewPoint: Float?
    let humidity: Float?
    let pressure: Float?
    let windSpeed: Float?
    let windGust: Float?
    let windBearing: Float?
    let cloudCover: Float?
    let uvIndex: Float?
    let visibility: Float?
    let ozone: Float?
}
