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
    
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var forecastImage: UIImageView!
    @IBOutlet var forecastDescription: UILabel!
    @IBOutlet var temperature: UILabel!
    
    @IBOutlet var forecastTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request.delegate = self
        request.getForecast(by: "Dublin")
        cityTextField.text = "Dublin"
    }


    @IBAction func searchCityForecast(_ sender: Any) {
        
        request.getForecast(by: cityTextField.text ?? "Dublin")
    }
    
    
    
    // MARK: Request delegate
    
    func didRetrieveForecast(_ data: [Forecast]?) {
        if let forecastData = data {
            
            DispatchQueue.main.async {
                self.forecastDescription.text = forecastData[0].weather[0].main
                self.temperature.text = self.convertTemperature(forecastData[0].main.temp, from: .kelvin, to: .celsius)
                self.forecastImage.image = self.convertImage(from: forecastData[0].weather[0].main)
            }
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
    
    
    // MARK: Convertions
    
    func convertTemperature(_ temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: UnitTemperature.kelvin)
        let output = input.converted(to: UnitTemperature.celsius)
        return mf.string(from: output)
    }
    
    func convertImage(from description: String) -> UIImage {
        
        switch description {
        case "Thunderstorm":
            return UIImage(named: "storm")!
        case "Drizzle":
            return UIImage(named: "rain")!
        case "Rain":
            return UIImage(named: "rain")!
        case "Snow":
            return UIImage(named: "snow")!
        case "Clear":
            return UIImage(named: "sunny")!
        case "Clouds":
            return UIImage(named: "clouds")!
        default:
            return UIImage(named: "haze")!
                  
        }
    }
}

