//
//  ViewController.swift
//  WiproForecast
//
//  Created by Cris Burlamaqui on 13/07/2020.
//  Copyright © 2020 Cris Burlamaqui. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RequestDelegate, UITextFieldDelegate {
    
    
    
    let request = Request()
    
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var forecastImage: UIImageView!
    @IBOutlet var forecastDescription: UILabel!
    @IBOutlet var temperature: UILabel!
    
    @IBOutlet var forecastTableView: UITableView!
    
    var forecastArrayList: [Forecast] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTextField.delegate = self
        request.delegate = self
        cityTextField.text = "Dublin"
        searchCityForecast(nil)
    }


    @IBAction func searchCityForecast(_ sender: Any?) {
        
        forecastArrayList = []
        cityTextField.resignFirstResponder()
        
        let city = "Dublin,ie"
        cityTextField.text = cityTextField.text ?? city
        request.getForecast(by: cityTextField.text!.elementsEqual("Dublin") ? city : cityTextField.text!)
    }
    
    
    // MARK: Text field method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchCityForecast(nil)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: .letters) != nil || string == "" || string == "," {
            return true
        }else {
            let alert = UIAlertController.init(title: "Invalid", message: "Only letters allowed", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "Ok", style: .cancel)
            alert.addAction(cancel)
            present(alert, animated: true)
            return false
        }
    }
    
    
    
    // MARK: Request delegate - Loading and processing data
    
    func didRetrieveForecast(_ data: [Forecast]?) {
        
        DispatchQueue.main.async {
            if let forecastListData = data {
                self.processForecastList(forecastListData)
            }
            else {
                self.showNotFoundMsg()
            }
        }
    }
    
    func processForecastList(_ data:  [Forecast]) {
        
        var weekDays: [String: [Forecast]] = [:]
        var weekArray = Array<Forecast>()
        weekArray.append(data[0])
        
        for i in 1..<data.count {
            
            if data[i].dt_txt == data[i - 1].dt_txt {
                weekArray.append(data[i])
                continue
            }
            weekDays.updateValue(weekArray, forKey: data[i - 1].dt_txt)
            weekArray = []
        }
        
        let sortedWeekDays = weekDays.sorted { $0.key < $1.key }
        
        loadWeatherList(from: sortedWeekDays)
        
    }
    
    func loadWeatherList(from forecastDictionary: [Dictionary<String, [Forecast]>.Element]) {
        
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
        self.temperature.text = "\(Int(self.forecastArrayList[0].main.temp))ºC"
        self.forecastImage.image = self.convertImage(from: forecastArrayList[0].weather[0].main)
        
        self.forecastTableView.reloadData()
    }
    
    func showNotFoundMsg() {
        
        let alert = UIAlertController.init(title: nil, message: "City not found", preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "Ok", style: .cancel) { (UIAlertAction) in
            self.cityTextField.text = "Dublin"
            self.searchCityForecast(nil)
        }
        
        alert.addAction(cancel)
        self.present(alert, animated: true)
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
        if indexPath.row == 0 {
            cell.weekDay.text = "Today"
        }
        else {
            cell.weekDay.text = cell.getWeekDayText(from: forecast.dt_txt)
        }
        cell.minTemp.text = "min. \(Int(forecast.main.temp_min))ºC"
        cell.maxTemp.text = "max. \(Int(forecast.main.temp_max))ºC"
        cell.forecastDescription.text = forecast.weather[0].description
        
        return cell
    }
    
    
    // MARK: Data convertions
    
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

