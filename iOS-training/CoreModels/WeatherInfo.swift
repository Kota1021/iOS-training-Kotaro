//
//  WeatherInfo.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/14.
//
import Foundation

struct WeatherInfo: Decodable {
    let maxTemperature: Int
    let date: Date
    let minTemperature: Int
    let weatherCondition: Weather
}

extension WeatherInfo: Equatable {}

extension WeatherInfo: Hashable {}
