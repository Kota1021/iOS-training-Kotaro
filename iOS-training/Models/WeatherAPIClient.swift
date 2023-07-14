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

            let areaDateJSON = try generateJSONFromAreaDate(areaDate) // can throw JSONError.failedToStringify
            let fetchedWeatherJSON = try YumemiWeather.fetchWeather(areaDateJSON) // can throw YumemiWeatherError.invalidParameterError and \.unknownError
            let weatherDateTemperature = try generateWeatherDateTemperatureFrom(json: fetchedWeatherJSON) // can throw JSONError.failedToStringify
            return weatherDateTemperature
        }

        return weatherDateTemperature
    }
}

// ----------------------
extension WeatherAPIClient {
    // MARK: Below JSON related

    // c.f. https://medium.com/@bj1024/swift4-codable-json-encode-17eaa95372d1

    // MARK: - input

    private struct AreaDate: Encodable {
        //    Example
        //    {
        //        "area": "tokyo",
        //        "date": "2020-04-01T12:00:00+09:00"
        //    }
        let area: String
        let date: Date
    }

    private func generateJSONFromAreaDate(_ areaDate: AreaDate) throws -> String {
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        // 末尾のZはZulu timeの略
        // c.f. https://qiita.com/yosshi4486/items/6703c9f42d9b33c936e7
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        encoder.dateEncodingStrategy = .formatted(formatter)

        let areaDateJSONData = try encoder.encode(areaDate)
        let areaDateJSON = String(data: areaDateJSONData, encoding: .utf8)

        guard let areaDateJSON else { throw JSONError.failedToStringify }
        return areaDateJSON
    }

    // MARK: - output

    private func generateWeatherDateTemperatureFrom(json: String) throws -> WeatherDateTemperature {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let fetchedWeatherJSON = json.data(using: .utf8)
        guard let fetchedWeatherJSON else { throw JSONError.failedToStringify }

        let weatherDateTemperature = try decoder.decode(WeatherDateTemperature.self, from: fetchedWeatherJSON)
        return weatherDateTemperature
    }

    enum JSONError: Error, LocalizedError {
        case failedToStringify
        var errorDescription: String? {
            switch self {
            case .failedToStringify:
                "failed To Stringify JSON"
            }
        }
    }

    // MARK: for testing

    // let decoder: JSONDecoder = JSONDecoder()
    // decoder.dateDecodingStrategy = .iso8601
    // do {
    //    let decoded: WeatherDateTemperature = try decoder.decode(WeatherDateTemperature.self, from: jsonString.data(using: .utf8)!)
    //    print(decoded)
    // } catch {
    //    print(error.localizedDescription)
    // }
}
