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
    
    var forecastArrayList: [Forecast] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request.delegate = self
        request.getForecast(by: "Dublin")
        cityTextField.text = "Dublin"
    }


    @IBAction func searchCityForecast(_ sender: Any) {
        
        request.getForecast(by: cityTextField.text ?? "Dublin")
    }
    
    
    
    // MARK: Request delegate - Load data
    
    func didRetrieveForecast(_ data: [Forecast]?) {
        if let forecastData = data {
            
            DispatchQueue.main.async {
                
                self.loadWeatherList(forecastData)
            }
        }
    }
    
    func loadWeatherList(_ data:  [Forecast]) {
        
        var weekDays: [String: [Forecast]] = [:]
        var weekArray = Array<Forecast>()
        weekArray.append(data[0])
        
        for i in 1..<data.count {
            
            if data[i].dt_txt == data[i - 1].dt_txt {
                weekArray.append(data[i])
                continue
            }
            weekDays.updateValue(weekArray, forKey: data[i].dt_txt)
            weekArray = []
        }
        
        proccessWeatherListData(weekDays.sorted { $0.key < $1.key })
        
    }
    
    func proccessWeatherListData(_ forecastDictionary: [Dictionary<String, [Forecast]>.Element]) {
        
        for forecastList in forecastDictionary {
            
            let forecasts = forecastList.value as [Forecast]
            
            let mainList = forecasts.map { $0.main }
            
            let averageTemp = mainList.reduce(into: 0.0) { (result, main) in
                result += main.temp
            } / Double(mainList.count)
            
            let averageMinTemp = mainList.reduce(into: 0.0) { (result, main) in
                result += main.temp_min
            } / Double(mainList.count)
            
            let averageMaxTemp = mainList.reduce(into: 0.0) { (result, main) in
                result += main.temp_max
            } / Double(mainList.count)
            
            let main = Main.init(temp: averageTemp, tempMin: averageMinTemp, tempMax: averageMaxTemp)
            let forecast = Forecast.init(main: main, weather: forecastList.value[0].weather, dateString: forecastList.key)
            
            self.forecastArrayList.append(forecast)
        }
        
        self.forecastDescription.text = self.forecastArrayList[0].weather[0].main
        self.temperature.text = self.convertTemperature(self.forecastArrayList[0].main.temp)
        self.forecastImage.image = self.convertImage(from: forecastArrayList[0].weather[0].main)
        
        self.forecastTableView.reloadData()
    }
    
    
    
    // MARK: Table view methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastArrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell
        
        let forecast = forecastArrayList[indexPath.row]
        cell.forecastIcon.image = convertImage(from: forecast.weather[0].main)
        cell.weekDay.text = cell.getWeekDayText(from: forecast.dt_txt)
        cell.minTemp.text = convertTemperature(forecast.main.temp_min)
        cell.maxTemp.text = convertTemperature(forecast.main.temp_max)
        cell.forecastDescription.text = forecast.weather[0].description
        
        return cell
    }
    
    
    // MARK: Convertions
    
    func convertTemperature(_ temp: Double, from inputTempType: UnitTemperature = .kelvin, to outputTempType: UnitTemperature = .celsius) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
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

