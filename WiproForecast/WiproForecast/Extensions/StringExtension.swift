//
//  StringExtension.swift
//  WiproForecast
//
//  Created by Cris Burlamaqui on 13/07/2020.
//  Copyright © 2020 Cris Burlamaqui. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func convertToWeekDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let date = dateFormatter.date(from: self)
        let weekDay = dateFormatter.string(from: date ?? Date())
        return weekDay
    }
}
