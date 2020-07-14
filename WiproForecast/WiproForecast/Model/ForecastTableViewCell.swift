//
//  ForecastTableViewCell.swift
//  WiproForecast
//
//  Created by Cris Burlamaqui on 13/07/2020.
//  Copyright © 2020 Cris Burlamaqui. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var forecastIcon: UIImageView!
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var forecastDescription: UILabel!
    
    func getWeekDayText(from weekDay: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: weekDay)!
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }

}
