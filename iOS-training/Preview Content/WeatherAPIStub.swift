//
//  WeatherAPIStub.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/09/29.
//

import Foundation
import YumemiWeather

struct WeatherAPIStub: WeatherAPI {
    func fetchWeatherInfo(in _: String, at _: Date) async throws -> WeatherInfo {
        let date = Date(timeIntervalSince1970: 0)
        let weatherInfo = WeatherInfo(
            maxTemperature: 30,
            date: date,
            minTemperature: 20,
            weatherCondition: Weather.allCases.randomElement()!
        )
        return weatherInfo
    }
    
    func fetchWeatherInfo(of weather: Weather) -> WeatherInfo {
        let date = Date(timeIntervalSince1970: 0)
        let weatherInfo = WeatherInfo(
            maxTemperature: 30,
            date: date,
            minTemperature: 20,
            weatherCondition: weather
        )
        return weatherInfo
    }
}
