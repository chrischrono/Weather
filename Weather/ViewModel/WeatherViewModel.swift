//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Christian on 21/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation


class WeatherViewModel {
    private var forecastResponse: ForecastResponse?
    private(set) var forecast = [String: String]() {
        didSet {
            reloadForecastDataClosure?()
        }
    }
    private(set) var isLoading = false {
        didSet {
            showLoadingViewClosure?(isLoading)
        }
    }
    private(set) var status: String? {
        didSet {
            updateStatusViewClosure?(status)
        }
    }
    
    var networkManager: DarkskyAPINetworkProtocol = DarkskyAPINetworkManager(environment: .production)
    
    
    var reloadForecastDataClosure: (()->())?
    var showLoadingViewClosure: ((Bool)->())?
    var updateStatusViewClosure: ((String?)->())?

}

//MARK:- getForecast related
extension WeatherViewModel {
    func getForecast(latitude: Double, longitude: Double) {
        guard isLoading == false else {
            return
        }
        
        status = "network_loading"
        networkManager.getForecast(latitude: latitude, longitude: longitude) { [weak self] (forecastResponse, error) in
            guard let self = self else {
                return
            }
            self.isLoading = false
            guard error == nil else {
                self.status = error
                return
            }
            guard let forecastResponse = forecastResponse else {
                return
            }
            
            self.processForecastResponse(forecastResponse)
        }
    }
    
    private func processForecastResponse(_ forecastResponse: ForecastResponse) {
        self.forecastResponse = forecastResponse
        let forecast = forecastResponse.currently
        var details = [String: String]()
        details[ForecastFields.timezone.rawValue] = forecastResponse.timezone
        details[ForecastFields.time.rawValue] = DateConverter.timeIntervalToHourString(forecast.time, timeZone: TimeZone.current)
        details[ForecastFields.summary.rawValue] = forecast.summary
        details[ForecastFields.icon.rawValue] = forecast.icon
        details[ForecastFields.precipIntensity.rawValue] = stringValue( forecast.precipIntensity)
        details[ForecastFields.precipProbability.rawValue] = stringValue(forecast.precipProbability)
        details[ForecastFields.temperature.rawValue] = stringValue(forecast.temperature)
        details[ForecastFields.apparentTemperature.rawValue] = stringValue(forecast.apparentTemperature)
        details[ForecastFields.dewPoint.rawValue] = stringValue(forecast.dewPoint)
        details[ForecastFields.humidity.rawValue] = stringValue(forecast.humidity)
        details[ForecastFields.pressure.rawValue] = stringValue(forecast.pressure)
        details[ForecastFields.windSpeed.rawValue] = stringValue(forecast.windSpeed)
        details[ForecastFields.windGust.rawValue] = stringValue(forecast.windGust)
        details[ForecastFields.windBearing.rawValue] = stringValue(forecast.windBearing)
        details[ForecastFields.cloudCover.rawValue] = stringValue(forecast.cloudCover)
        details[ForecastFields.uvIndex.rawValue] = stringValue(forecast.uvIndex)
        details[ForecastFields.visibility.rawValue] = stringValue(forecast.visibility)
        details[ForecastFields.ozone.rawValue] = stringValue(forecast.ozone)
        
    }
    
    private func stringValue(_ float: Float?) -> String? {
        guard let float = float else {
            return nil
        }
        return "\(float)"
    }
    
    
}



/** enum for iterating the fields of user data. */
enum ForecastFields: String, CaseIterable {
    case timezone = "Timezone"
    case time = "Time"
    case summary = "Summary"
    case icon = "Icon"
    case precipIntensity = "Precip Intensity"
    case precipProbability = "Precip Probability"
    case temperature = "Temperature"
    case apparentTemperature = "Apparent Temperature"
    case dewPoint = "Dew Point"
    case humidity = "Humidity"
    case pressure = "Pressure"
    case windSpeed = "Wind Speed"
    case windGust = "Wind Gust"
    case windBearing = "Wind Bearing"
    case cloudCover = "Cloud Cover"
    case uvIndex = "UV Index"
    case visibility = "Visibility"
    case ozone = "Ozone"
}
