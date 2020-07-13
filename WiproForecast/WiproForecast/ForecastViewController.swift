//
//  ViewController.swift
//  WiproForecast
//
//  Created by Cris Burlamaqui on 13/07/2020.
//  Copyright © 2020 Cris Burlamaqui. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RequestDelegate {
    
    
    
    let request = Request()
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var forecastImage: UIImageView!
    @IBOutlet weak var forecastDescription: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var forecastTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request.delegate = self
        request.getForecast(by: "Dublin")
    }


    @IBAction func searchCityForecast(_ sender: Any) {
        
    }
    
    
    
    // MARK: Request delegate
    
    func didRetrieveForecast(_ data: [Forecast]?) {
        if let forecastData = data {
            print(forecastData)
        }
    }
    
    
    
    // MARK: Table view methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell
        
        return cell
    }
}

