//
//  FetchManager.swift
//  FetchManager
//
//  Created by 松本 幸太郎 on 2023/10/13.
//

import Foundation

@Observable
class FetchManager {
    init(weatherAPI: WeatherAPI) {
        self.weatherAPI = weatherAPI
    }

    private let weatherAPI: WeatherAPI

    var fetched: WeatherDateTemperature? {
        if case let .succeeded(weatherDateTemperature) = fetchState {
            weatherDateTemperature
        } else {
            nil
        }
    }

    var error: Error? {
        if case let .failed(error) = fetchState {
            error
        } else {
            nil
        }
    }

    private var fetchState: FetchState = .initial
    private enum FetchState {
        case initial
        case succeeded(WeatherDateTemperature)
        case failed(Error)
    }

    func fetch() {
            do {
                let weatherDateTemperature = try weatherAPI.fetchWeatherCondition(in: "tokyo", at: Date())
                fetchState = .succeeded(weatherDateTemperature)
            } catch {
                fetchState = .failed(error)
            }
    }

    func reset() {
        fetchState = .initial
    }
}
