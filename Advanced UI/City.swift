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
    var longDescription: String
    
    init(name: String, location: Location) {
        self.cityName = name
        self.location = location
        self.longDescription = name
    }
    
    init(data: [String: Any]) {
        let longDesc = data["display_name"] as! String
        let descParts = longDesc.components(separatedBy: ",")
        self.cityName = descParts.first!
        self.location = Location(
            latitude: Double(data["lat"] as! String)!,
            longitude: Double(data["lon"] as! String)!
        )
        self.longDescription = "\(cityName), \(descParts[1]), \(descParts.last!)"
    }
    
    init(address: [String: Any], location: Location) {
        self.location = location
        let country = address["country"] as! String
        if let city = address["city"] as? String {
            self.cityName = city
            self.longDescription = "\(city), \(country)"
        } else if let village = address["village"] as? String {
            self.cityName = village
            self.longDescription = "\(village), \(country)"
        } else if let hamlet = address["hamlet"] as? String {
            self.cityName = hamlet
            self.longDescription = "\(hamlet), \(country)"
        } else {
            let state = address["state"] as! String
            self.cityName = state
            self.longDescription = "\(state), \(country)"
        }
    }
    
    func setWheatherData(data : [[String:Any]]) -> Void {
        data.forEach({ (element) in
            self.wheather.append(WheatherData(data:element))
        })
    }

}
