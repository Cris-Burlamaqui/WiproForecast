//
//  Main.swift
//  WiproForecast
//
//  Created by Cris Burlamaqui on 13/07/2020.
//  Copyright © 2020 Cris Burlamaqui. All rights reserved.
//

import Foundation

struct Main: Codable {
    
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    
    init(temp: Double, tempMin: Double, tempMax: Double) {
        self.temp = temp
        self.temp_min = tempMin
        self.temp_max = tempMax
    }
    
}
