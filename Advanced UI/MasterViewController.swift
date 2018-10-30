//
//  MasterViewController.swift
//  Advanced UI
//
//  Created by user147535 on 10/22/18.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit

protocol CitySelectionDelegate: class {
    func citySelected(_ newCity: City)
}

class MasterViewController: UITableViewController {

    var cities:[City] = []
    weak var delegate: CitySelectionDelegate?
    var cityCount = 0;
    var wheatherGetter: WeatherGetter = WeatherGetter()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tmpCities = [
            City(name: "Krakow", location: Location(latitude:50.06, longitude:19.93)),
            City(name: "Wroclaw", location: Location(latitude:51.07 , longitude: 17.02)),
            City(name: "Warszawa", location: Location(latitude: 52.13, longitude: 21.00))
        ]
        tmpCities.forEach { (city) in
            wheatherGetter.getWeather(city: city, callback: { (wheather) in
                city.setWheatherData(data: wheather)
                self.cities.append(city)
                self.cityCount += 1
                self.tableView.reloadData()
                if (self.cityCount == 1) {
                    self.delegate?.citySelected(self.cities.first!)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityCount == cities.count ? cityCount : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let wheatherData = cities[indexPath.row].wheather.first {
            cell.imageView?.image=UIImage(named: wheatherData.iconName)
            var avgTemp = ((wheatherData.tempHigh + wheatherData.tempLow) / 2)
            avgTemp = Double(round(10 * avgTemp) / 10)
            cell.textLabel?.text = "\(cities[indexPath.row].cityName)"
            cell.detailTextLabel?.text = "\(avgTemp)°C"

        } else {
            cell.textLabel?.text = cities[indexPath.row].cityName

        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        delegate?.citySelected(selectedCity)
        if let detailViewController = delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
    
    @IBAction func unwindToCityList(sender: UIStoryboardSegue) {
        if let source = sender.source as? CitySearchViewController,
            let newCity = source.cityToBeAdded {
            let newIndexPath = IndexPath(row: self.cities.count, section: 0)
            self.tableView.beginUpdates()
            self.cities.append(newCity)
            self.cityCount += 1
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }

}

extension MasterViewController:UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
