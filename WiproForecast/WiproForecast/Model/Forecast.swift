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
}

struct Forecast: Codable {
    
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}
