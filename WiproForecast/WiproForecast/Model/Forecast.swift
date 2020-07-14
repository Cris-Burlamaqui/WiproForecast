//
//  Forecast.swift
//  WiproForecast
//
//  Created by Cris Burlamaqui on 13/07/2020.
//  Copyright © 2020 Cris Burlamaqui. All rights reserved.
//

import Foundation

struct ForecastList: Codable {
    
    let list: [Forecast]
    
    init(list: [Forecast]) {
        var forecastArray: [Forecast] = []
        
        for forecast in list {
            forecastArray.append(Forecast.init(main: forecast.main, weather: forecast.weather, dateString: forecast.dt_txt))
        }
        
        self.list = forecastArray
    }
}

struct Forecast: Codable {
    
    let main: Main
    let weather: [Weather]
    let dt_txt: String
    
    init(main: Main, weather: [Weather], dateString: String) {
        self.main = main
        self.weather = weather
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let d = date {
            self.dt_txt = dateFormatter.string(from: d)
        }
        else {
             self.dt_txt = dateString
        }
    }
}
