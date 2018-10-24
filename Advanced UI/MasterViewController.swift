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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tmpCities = [
            City(name: "Krakow", location: Location(latitude:19.07, longitude:50.03)),
            City(name: "Wroclaw", location: Location(latitude:17.02 , longitude: 51.07)),
            City(name: "Warszawa", location: Location(latitude: 21.00, longitude: 52.13))
        ]
        tmpCities.forEach { (city) in
            city.fetchWheatherData {
                self.cities.append(city)
                self.cityCount += 1
                self.tableView.reloadData()
            }
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
        cell.textLabel?.text = cities[indexPath.row].cityName
        if let wheatherData = cities[indexPath.row].wheather.first {
            cell.imageView?.image=UIImage(named: wheatherData.iconName)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MasterViewController:UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
