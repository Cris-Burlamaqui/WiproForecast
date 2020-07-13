//
//  DoubleExtension.swift
//  WiproForecast
//
//  Created by Cris Burlamaqui on 13/07/2020.
//  Copyright © 2020 Cris Burlamaqui. All rights reserved.
//

import Foundation

extension Double {
    func convertToCelcius() -> Int {
        Int(5.0 / 9.0 * (self - 32.0))
    }
}
