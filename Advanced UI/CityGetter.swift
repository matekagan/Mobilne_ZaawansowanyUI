//
//  CityGetter.swift
//  Advanced UI
//
//  Created by user147535 on 10/25/18.
//  Copyright © 2018 agh. All rights reserved.
//

import Foundation

class CityGetter {
    var baseUrl = "https://nominatim.openstreetmap.org/search?q="
    var requestArguments = "&format=json&limit=10&dedupe=1"
    
    func findCities(query: String, callback: @escaping ([[String:Any]]) -> Void) {
        let session = URLSession.shared
        var queryTrim = query.trimmingCharacters(in: .whitespacesAndNewlines)
        queryTrim = query.replacingOccurrences(of: " ", with: "-")
        let cityRequestURL = URL(string: "\(baseUrl)\(queryTrim)\(requestArguments)")!
        let dataTask = session.dataTask(with: cityRequestURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                // Case 1: Error
                print("Error:\n\(error)")
            }
            else {
                let jsonObj : [[String: Any]]?
                
                do {
                    try jsonObj = JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]
                    DispatchQueue.main.async {
                        callback(jsonObj!)
                    }
                } catch {
                    print("ERROR")
                }
            }
        }
        dataTask.resume()
    }
    
}
