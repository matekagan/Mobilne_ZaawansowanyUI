//
//  DetailViewController.swift
//  Advanced UI
//
//  Created by user147535 on 10/22/18.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var precip: UILabel!
    
    var city: City? {
        didSet {
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func refreshUI() -> Void {
        loadViewIfNeeded()
        let wheather = city?.wheather[0]
        temperature.text = "temp: \(wheather?.tempLow)°C - \(wheather?.tempHigh)°C"
        wind.text = "wind: \(wheather?.windSpeed) \(wheather?.windDirection.description)"
        pressure.text = "pressure: \(wheather?.pressure)"
        precip.text = "pressure: \(wheather?.precip)"
        icon.image = UIImage(named: wheather?.iconName ?? "clear-day")
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
