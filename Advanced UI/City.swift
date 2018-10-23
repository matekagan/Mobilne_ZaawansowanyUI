//
//  City.swift
//  Advanced UI
//
//  Created by Student on 23/10/2018.
//  Copyright © 2018 agh. All rights reserved.
//

import Foundation

struct Location {
    var latitude: Double
    var longitude: Double
}

class City {
    var cityName: String
    var location: Location
    var wheather: [WheatherData] = []
    
    init(name: String, location: Location) {
        self.cityName = name
        self.location = location
        let wheatherGetter = WeatherGetter()
        wheatherGetter.getWeather(city: self) { (data) in
            data.forEach({ (element) in
                self.wheather.append(WheatherData(data:element))
            })
        }
    }
}
