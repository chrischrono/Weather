//
//  DateConverterTests.swift
//  WeatherTests
//
//  Created by Christian on 22/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import XCTest
@testable import Weather

class DateConverterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testConvertTimeIntervalToHourString() {
        
        let timeIntervals: [Double] = [
            1555848000, 1555851600, 1555855200, 1555858800,
            1555862400, 1555866000, 1555869600, 1555873200,
            1555876800, 1555880400
        ]
        let results: [String] = ["19:00", "20:00", "21:00", "22:00",
                                  "23:00", "00:00", "01:00", "02:00",
                                  "03:00", "04:00"]
        let timeZone = TimeZone(abbreviation: "GMT+07")!//identifier
        
        for i in 0..<timeIntervals.count {
            let hourString = DateConverter.timeIntervalToHourString(timeIntervals[i], timeZone: timeZone)
            XCTAssertEqual(hourString, results[i])
        }
    }

}
