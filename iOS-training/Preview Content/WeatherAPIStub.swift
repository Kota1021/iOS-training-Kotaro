//
//  WeatherAPIStub.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/09/29.
//

import Foundation
import YumemiWeather

struct WeatherAPIStub: WeatherAPI {
    func fetchWeatherCondition(in _: String, at _: Date) -> Result<WeatherDateTemperature, Error> {
        let date = Date(timeIntervalSince1970: 0)
        let randomWeather = Weather.allCases.randomElement()!
        let weatherDateTemperature = WeatherDateTemperature(maxTemperature: 30,
                                                            date: date,
                                                            minTemperature: 20,
                                                            weatherCondition: randomWeather)
        return Result(catching: { weatherDateTemperature })
    }
}
