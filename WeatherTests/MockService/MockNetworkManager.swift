//
//  MockNetworkManager.swift
//  WeatherTests
//
//  Created by Christian on 22/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation
@testable import Weather


class MockNetworkManager: DarkskyAPINetworkProtocol {
    
    
    var mockForecastResponse: ForecastResponse?
    var mockError: String?
    
    required init(environment: NetworkEnvironment) {
    }
    
    
    func getForecast(latitude: Double, longitude: Double, completion: @escaping (ForecastResponse?, String?) -> ()) {
        completion(mockForecastResponse, mockError)
    }
}
