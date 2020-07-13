//
//  ViewController.swift
//  WiproForecast
//
//  Created by Cris Burlamaqui on 13/07/2020.
//  Copyright © 2020 Cris Burlamaqui. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var forecastImage: UIImageView!
    @IBOutlet weak var forecastDescription: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var forecastTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func searchCityForecast(_ sender: Any) {
    }
}

