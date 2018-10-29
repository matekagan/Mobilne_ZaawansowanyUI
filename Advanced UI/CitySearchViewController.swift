//
//  ViewController.swift
//  Advanced UI
//
//  Created by user147535 on 10/22/18.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit
import CoreLocation

protocol CityAddDelegate: class {
    func addCity(_ newCity: City)
}

class CitySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cityGetter = CityGetter()
    let locationManager = CLLocationManager()
    var cities: [City] = []
    var weatherGetter = WeatherGetter()
    var cityToBeAdded: City?
    weak var delegate: CityAddDelegate?

    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var citySearchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resultTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tapGesureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tapGesureRecognizer.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tapGesureRecognizer)
        restoreTable()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTable.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].longDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        weatherGetter.getWeather(city: selectedCity) { (data) in
            selectedCity.setWheatherData(data: data)
            self.cityToBeAdded = selectedCity
            self.performSegue(withIdentifier: "saveCity", sender: self)
        }
    }
    
    @IBAction func onEditEnd(_ sender: Any) {
        self.view.endEditing(true)
    }

    
    @IBAction func useCurrentLocation(_ sender: Any) {
        weatherGetter.getWeather(city: cityToBeAdded!) { (data) in
            self.cityToBeAdded!.setWheatherData(data: data)
            self.performSegue(withIdentifier: "saveCity", sender: self)
        }
    }
    
    @IBAction func onSearchSubmit(_ sender: Any) {
        self.view.endEditing(true)
        let searchQuery = citySearchField.text!
        cities.removeAll()
        if (!searchQuery.isEmpty) {
            cityGetter.findCities(query: searchQuery) { (cityData) in
                if (!cityData.isEmpty) {
                    self.restoreTable()
                    cityData.forEach({ (cityElement) in
                        let placeClass = cityElement["class"] as! String
                        if (placeClass == "place") {
                            self.cities.append(City(data: cityElement))
                            self.resultTable.reloadData()
                        }
                    })
                } else {
                    self.setEmptyMessage("No Cities to Show")
                }
            }
        }
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: self.resultTable.bounds.size.width,
            height: self.resultTable.bounds.size.height
            )
        )
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.resultTable.backgroundView = messageLabel;
        self.resultTable.separatorStyle = .none;
    }
    
    func restoreTable() {
        self.resultTable.backgroundView = nil
        self.resultTable.separatorStyle = .singleLine
    }
}

extension CitySearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude,
            let long = locations.last?.coordinate.longitude {
            let currLocation = Location(latitude: lat, longitude: long)
            cityGetter.findCity(location: currLocation) { (address) in
                self.cityToBeAdded = City(address: address, location: currLocation)
                let cityDesc : String = (self.cityToBeAdded?.longDescription)!
                self.currentLocationLabel.text = "You are in: \(cityDesc)"
                self.currentLocationButton.isEnabled = true
            }
        } else {
            print("No coordinates")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

