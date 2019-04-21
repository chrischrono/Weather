//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by Christian on 22/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherViewModelTests: XCTestCase {
    
    var weatherViewModel = WeatherViewModel()
    var mockNetworkManager = MockNetworkManager(environment: .qa)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        weatherViewModel.networkManager = mockNetworkManager
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGetForecastError() {
        mockNetworkManager.mockForecastResponse = nil
        mockNetworkManager.mockError = "This is an error"
        
        weatherViewModel.getForecast(latitude: 0, longitude: 0)
        XCTAssertEqual(weatherViewModel.status, mockNetworkManager.mockError)
    }
    
    func testGetForecast() {
        
        let data = loadDataFromBundle(withName: "forecast", extension: "json")
        let forecastResponse = try! JSONDecoder().decode(ForecastResponse.self, from: data)
        mockNetworkManager.mockForecastResponse = forecastResponse
        mockNetworkManager.mockError = nil
        
        weatherViewModel.getForecast(latitude: forecastResponse.latitude, longitude: forecastResponse.longitude)
        
        XCTAssertEqual(weatherViewModel.forecast.keys.count, 17)
    }

}
