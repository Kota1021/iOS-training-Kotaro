//
//  WeatherAPIStub.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/09/29.
//

import Foundation
import YumemiWeather

struct WeatherAPIStub: WeatherAPI {
    func fetchWeatherCondition(in _: String, at _: Date) throws -> WeatherDateTemperature {
        let date = Date(timeIntervalSince1970: 0)
        let weatherDateTemperature = WeatherDateTemperature(maxTemperature: 30,
                                                            date: date,
                                                            minTemperature: 20,
                                                            weatherCondition: Weather.allCases.randomElement()!)
        return weatherDateTemperature
    }
    
    func fetchWeatherCondition(of weather: Weather) -> WeatherDateTemperature {
        let date = Date(timeIntervalSince1970: 0)
        let weatherDateTemperature = WeatherDateTemperature(maxTemperature: 30,
                                                            date: date,
                                                            minTemperature: 20,
                                                            weatherCondition: weather)
        return weatherDateTemperature
    }
}
