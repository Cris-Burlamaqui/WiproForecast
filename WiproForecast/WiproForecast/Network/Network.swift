//
//  Network.swift
//  WiproForecast
//
//  Created by Cris Burlamaqui on 13/07/2020.
//  Copyright © 2020 Cris Burlamaqui. All rights reserved.
//

import Foundation

protocol RequestDelegate {
    func didRetrieveForecast(_ data: [Forecast]?)
}

class Request {
    
    var delegate: RequestDelegate!
    let apiKey = "879135c39c4af23ab79941be2c28d014"
    
    func requestData(from url: URL, and method: String) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                let data = data else { return }
            
            if httpResponse.statusCode == 200 {
                self.retrieveForecast(from: data)
            }
            else {
                self.delegate.didRetrieveForecast(nil)
            }
        }.resume()
    }
    
    func getForecast(by city: String) {
        
        let forecastUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)")!
        requestData(from: forecastUrl, and: "GET")
    }
    
    func retrieveForecast(from data: Data) {
        
        do {
            let decoder = JSONDecoder()
            let forecast = try decoder.decode(ForecastList.self, from: data)
            self.delegate.didRetrieveForecast(forecast.list)
        } catch let decodeError as NSError {
            print("Decode error: \(decodeError.localizedDescription)")
            return
        }
    }
}
