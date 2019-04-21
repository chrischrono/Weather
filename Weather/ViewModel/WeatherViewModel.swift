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
    private(set) var latitude: Double = 0
    private(set) var longitude: Double = 0
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
    private var locationManager = LocationManager()
    
    var reloadForecastDataClosure: (()->())?
    var showLoadingViewClosure: ((Bool)->())?
    var updateStatusViewClosure: ((String?)->())?

    
    func startWeatherForecasting() {
        initLocationManager()
        locationManager.requestLocation()
    }
}

//MARK:- getForecast related
extension WeatherViewModel {
    func userRequestForecast(latitude: String, longitude: String) {
        guard let latitude = Double(latitude), let longitude = Double(longitude) else {
            status = "weather_input_location_invalid"
            return
        }
        getForecast(latitude: latitude, longitude: longitude)
    }
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
            self.status = nil
            guard let forecastResponse = forecastResponse else {
                return
            }
            
            self.processForecastResponse(forecastResponse)
        }
    }
    
    private func processForecastResponse(_ forecastResponse: ForecastResponse) {
        self.forecastResponse = forecastResponse
        latitude = forecastResponse.latitude
        longitude = forecastResponse.longitude
        
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
        
        self.forecast = details
    }
    
    private func stringValue(_ float: Float?) -> String? {
        guard let float = float else {
            return nil
        }
        return "\(float)"
    }
    
    
}


//MARK: - locationManager related
extension WeatherViewModel {
    private func initLocationManager() {
        locationManager.locationUpdateClosure = { [weak self] (location, placemark) in
            guard let self = self else {
                return
            }
            if let location = location {
                print("Location: \(location.coordinate.latitude) - \(location.coordinate.longitude)")
                self.getForecast(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            } else {
                // cannot get user location
            }
        }
    }
}


/** enum for iterating the fields of forecast data. */
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
