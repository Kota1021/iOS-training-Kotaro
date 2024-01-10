//
//  WeatherAPI.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/09/27.
//

import Foundation
protocol WeatherAPI {
    func fetchWeatherInfo(in area: String, at date: Date) async throws -> WeatherInfo
    func fetchWeatherList(in areas: [String], at date: Date) async throws -> [AreaWeather]
}
