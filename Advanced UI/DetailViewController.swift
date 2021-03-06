//
//  DetailViewController.swift
//  Advanced UI
//
//  Created by user147535 on 10/22/18.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var precip: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var city: City? {
        didSet {
            refreshUI()
        }
    }
    
    var currentIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func refreshUI() -> Void {
        loadViewIfNeeded()
        if let wheather = city?.wheather[currentIndex]{
            temperature.text = "temp: \(wheather.tempLow)°C - \(wheather.tempHigh)°C"
            wind.text = "wind: \(wheather.windSpeed) m/s \(wheather.windDirection.description)"
            pressure.text = "pressure: \(wheather.pressure) hPa"
            precip.text = "precip: \(wheather.precip) mm/h"
            icon.image = UIImage(named: wheather.iconName)
            date.text = wheather.dateString
            cityName.text = city?.cityName
            checkButtons()
        }
    }

    func checkButtons() -> Void {
        nextButton.isEnabled = currentIndex < ((city?.wheather.count)! - 1)
        previousButton.isEnabled = currentIndex > 0
    }
    
    @IBAction func viewPrevDate(_ sender: Any) {
        currentIndex -= 1
        refreshUI()
    }
    
    @IBAction func viewNextDate(_ sender: Any) {
        currentIndex += 1
        refreshUI()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mapController = segue.destination as? MapViewController {
            mapController.city = self.city
        }
    }
    
}

extension DetailViewController: CitySelectionDelegate {
    func citySelected(_ newCity: City) {
        city = newCity
    }
}
