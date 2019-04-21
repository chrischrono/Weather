//
//  DateConverter.swift
//  Weather
//
//  Created by Christian on 21/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation


class DateConverter {
    public static func timeIntervalToHourString(_ timeInterval: TimeInterval, timeZone: TimeZone) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = timeZone
        
        let date = Date(timeIntervalSince1970: timeInterval)
        return dateFormatter.string(from: date)
    }
}
