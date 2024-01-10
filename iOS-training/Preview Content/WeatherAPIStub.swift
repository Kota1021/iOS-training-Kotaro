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

    func fetchWeatherList(in _: [String], at _: Date) async throws -> [AreaWeather] {
        var areaWeatherList = [AreaWeather]()
        let areas = [
            "Sapporo",
            "Sendai",
            "Niigata",
            "Kanazawa",
            "Tokyo",
            "Nagoya",
            "Osaka",
            "Hiroshima",
            "Kochi",
            "Fukuoka",
            "Kagoshima",
            "Naha",
        ]
            
        for (index, area) in zip(areas.indices, areas) {
            let date = Date(timeIntervalSince1970: 0)
            let weatherCondition = switch index {
            case 0: Weather.sunny
            case 1: Weather.cloudy
            case 2: Weather.rainy
            default: Weather.sunny
            }
            
            let weatherInfo = WeatherInfo(
                maxTemperature: 30 + index,
                date: date,
                minTemperature: 20 + index,
                weatherCondition: weatherCondition
            )
            let areaWeather = AreaWeather(area: area, info: weatherInfo)
            areaWeatherList.append(areaWeather)
        }
        return areaWeatherList
    }

    static let weatherInfo = WeatherInfo(
        maxTemperature: 30,
        date: Date(),
        minTemperature: 20,
        weatherCondition: .sunny
    )

    static let areaWeather = AreaWeather(area: "tokyo", info: weatherInfo)
}
