//
//  WeatherAPIClient.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/13.
//

import Foundation
import YumemiWeather

struct WeatherAPIClient {
    func fetchWeatherCondition(in area: String, at date: Date) -> Result<WeatherDateTemperature, Error>? {
        print("fetchWeatherCondition called")
        do {
            // MARK: Encoding into input JSON String

            let areaDate = AreaDate(area: area, date: date)
            let areaDateJSONString = generateJSONStringFromAreaDate(areaDate)

            // MARK: Decoding from output JSON String

            let fetchedWeatherJSONString = try YumemiWeather.fetchWeather(areaDateJSONString)
            let weatherDateTemperature = generateWeatherDateTemperatureFrom(json: fetchedWeatherJSONString)

            return .success(weatherDateTemperature)

        } catch let error as YumemiWeatherError {
            print("returned YumemiWeatherError")
            return .failure(error)
        } catch {
            print("returned Error")
            fatalError("LayoutPrototype: fetchWeatherCondition(at:) returned error \(error)")
        }
    }
}
