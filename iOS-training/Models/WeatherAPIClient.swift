//
//  WeatherAPIClient.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/13.
//

import Foundation
import YumemiWeather

struct WeatherAPIClient {
    func fetchWeatherCondition(in area: String, at date: Date) -> Result<WeatherDateTemperature, Error> {
        // MARK: Encoding into input JSON String

        let areaDate = AreaDate(area: area, date: date)
        let weatherDateTemperature = Result<WeatherDateTemperature, Error> {
            // MARK: Decoding from output JSON String

            let areaDateJSON = try generateJSONFromAreaDate(areaDate)
            let fetchedWeatherJSON = try YumemiWeather.fetchWeather(areaDateJSON) // can throw YumemiWeatherError.invalidParameterError and \.unknownError
            let weatherDateTemperature = try generateWeatherDateTemperatureFrom(json: fetchedWeatherJSON)
            return weatherDateTemperature
        }

        return weatherDateTemperature
    }

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        // 末尾のZはZulu timeの略
        // c.f. https://qiita.com/yosshi4486/items/6703c9f42d9b33c936e7
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
}

// ----------------------
extension WeatherAPIClient {
    // MARK: Below JSON related

    // c.f. https://medium.com/@bj1024/swift4-codable-json-encode-17eaa95372d1

    // MARK: - input

    private struct AreaDate: Encodable {
        let area: String
        let date: Date
    }

    private func generateJSONFromAreaDate(_ areaDate: AreaDate) throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        let areaDateJSONData = try encoder.encode(areaDate)
        let areaDateJSON = String(data: areaDateJSONData, encoding: .utf8)

        guard let areaDateJSON else {
            throw JSONError.failedToStringify
        }
        return areaDateJSON
    }

    // MARK: - output

    private func generateWeatherDateTemperatureFrom(json: String) throws -> WeatherDateTemperature {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase

            let weatherDateTemperature = try decoder.decode(WeatherDateTemperature.self, from: Data(json.utf8))
            return weatherDateTemperature
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
}
