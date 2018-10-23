//
//  File.swift
//  Advanced UI
//
//  Created by Student on 23/10/2018.
//  Copyright © 2018 agh. All rights reserved.
//

import Foundation


class WheatherData {
    
    var tempLow: Double
    var tempHigh: Double
    var pressure:Double
    var windSpeed: Double
    var windDirection: WindDirection
    var precip: Double
    var iconName: String
    var dateString: String
    
    init(data: [String:Any]) {
        tempLow = data["temperatureLow"]! as! Double
        tempHigh = data["temperatureHigh"]! as! Double
        
        pressure = data["pressure"]! as! Double
        
        windSpeed = data["windSpeed"]! as! Double
        windDirection = WindDirection(data["windBearing"]! as! Double)
        
        precip = data["precipIntensity"]! as! Double
        
        iconName = data["icon"]! as! String
        
        let date = Date(timeIntervalSince1970: data["time"]! as! Double)
        let dayTimeFormatter = DateFormatter()
        dayTimeFormatter.dateFormat = "dd MMMM YYY"
        dateString = dayTimeFormatter.string(from: date as Date)
    }
}
