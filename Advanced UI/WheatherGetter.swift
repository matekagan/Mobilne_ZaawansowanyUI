import Foundation

class WeatherGetter {
    
    private let darkSkyBaseApiURL = "https://api.darksky.net/forecast/307ff69f9c1ffcd18bd147431e2b0bc3"
    private let darkSkyArguments = "units=si&exclude=currently,minutely,hourly,alerts,flags"
    
    func getWeather(city: City, callback: @escaping ([[String:Any]]) -> Void) {
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: "\(darkSkyBaseApiURL)/\(city.location.latitude),\(city.location.longitude)?\(darkSkyArguments)")!
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(with: weatherRequestURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                // Case 1: Error
                print("Error:\n\(error)")
            }
            else {
                let jsonObj : [String: Any]?
                
                do {
                    try jsonObj = JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    
                    if let mainDictionary = jsonObj!["daily"] as? NSDictionary {
                        if let dataArray = mainDictionary.value(forKey: "data") {
                            // do something with the array
                            DispatchQueue.main.async {
                                // Do something ?
                                callback(dataArray as! [[String:Any]])
                            }
                        } else {
                            print("Unable to find data in JSON")
                        }
                    } else {
                        print("Error when parsing JSON")
                    }
                } catch {
                    print("ERROR")
                }
                
            }
        }
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
    
}
