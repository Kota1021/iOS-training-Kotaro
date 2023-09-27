//
//  WeatherAPIImpl.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/13.
//

import Foundation
import YumemiWeather

struct WeatherAPIImpl: WeatherAPI {
    func fetchWeatherCondition(in area: String, at date: Date) -> Result<WeatherDateTemperature, Error> {
        // MARK: Encoding into input JSON String

        let weatherDateTemperature = Result<WeatherDateTemperature, Error> {
            // MARK: Decoding from output JSON String

            let requestJSON = try WeatherRequestEncoder().generateRequestJSON(area: area, date: date)
            let fetchedWeatherJSON = try YumemiWeather.fetchWeather(requestJSON) // can throw YumemiWeatherError.invalidParameterError and \.unknownError
            let weatherDateTemperature = try WeatherDateTemperatureDecoder().generateWeatherDateTemperature(from: fetchedWeatherJSON)
            return weatherDateTemperature
        }

        return weatherDateTemperature
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    // 末尾のZはZulu timeの略
    // c.f. https://qiita.com/yosshi4486/items/6703c9f42d9b33c936e7
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter
}()

struct WeatherRequestEncoder {
    func generateRequestJSON(area: String, date: Date) throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        let areaDateJSONData = try encoder.encode(AreaDate(area: area, date: date))
        let areaDateJSON = String(data: areaDateJSONData, encoding: .utf8)

        guard let areaDateJSON else {
            throw JSONError.failedToStringify
        }
        return areaDateJSON
    }

    enum JSONError: Error, LocalizedError {
        case failedToStringify
        var errorDescription: String? {
            switch self {
            case .failedToStringify:
                "failed to stringify JSON"
            }
        }
    }

    private struct AreaDate: Encodable {
        let area: String
        let date: Date
    }
}

struct WeatherDateTemperatureDecoder {
    // MARK: - output

    func generateWeatherDateTemperature(from json: String) throws -> WeatherDateTemperature {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let weatherDateTemperature = try decoder.decode(WeatherDateTemperature.self, from: Data(json.utf8))
        return weatherDateTemperature
    }
}
