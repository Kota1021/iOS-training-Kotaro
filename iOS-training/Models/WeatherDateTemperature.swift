//
//  WeatherDateTemperature.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/14.
//
import Foundation

struct WeatherDateTemperature: Decodable {
    //    Example
    //    {
    //        "max_temperature":25,
    //        "date":"2020-04-01T12:00:00+09:00",
    //        "min_temperature":7,
    //        "weather_condition":"cloudy"
    //    }
    let maxTemperature: Int
    let date: Date // ISO 8601
    let minTemperature: Int
    let weatherCondition: Weather

    enum CodingKeys: String, CodingKey {
        case maxTemperature = "max_temperature"
        case date
        case minTemperature = "min_temperature"
        case weatherCondition = "weather_condition"
    }
}
