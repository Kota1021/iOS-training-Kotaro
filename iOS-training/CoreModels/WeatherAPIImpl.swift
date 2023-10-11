//
//  WeatherAPIImpl.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/13.
//

import Foundation
import YumemiWeather

struct WeatherAPIImpl: WeatherAPI {
    func fetchWeatherInfo(in area: String, at date: Date) async throws -> WeatherInfo {
        let requestJSON = try WeatherRequestGenerator().generate(area: area, date: date)
        let fetchedWeatherJSON = try await YumemiWeather.asyncFetchWeather(requestJSON) // may throw YumemiWeatherError.invalidParameterError and \.unknownError
        let weatherInfo = try WeatherInfoGenerator().generate(from: fetchedWeatherJSON)
        return weatherInfo
    }

    func fetchWeatherList(in areas: [String], at date: Date) async throws -> [AreaWeather] {
        // MARK: Encoding into input JSON String

        let requestJSON = try AreaWeatherListRequestGenerator().generate(areas: areas, date: date)
        let fetchedWeatherListJSON = try await YumemiWeather.asyncFetchWeatherList(requestJSON)

        // MARK: Decoding from output JSON String

        let areaWeatherList = try AreaWeatherListGenerator().generate(from: fetchedWeatherListJSON)
        return areaWeatherList
    }
}

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    // 末尾のZはZulu timeの略
    // c.f. https://qiita.com/yosshi4486/items/6703c9f42d9b33c936e7
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter
}()

// TODO: Generarize Generators for WeatherDateTemperature and AreaWeatherList

// MARK: WeatherDateTemperature

struct WeatherRequestGenerator {
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    
    func generate(area: String, date: Date) throws -> String {
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

struct WeatherInfoGenerator {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func generate(from json: String) throws -> WeatherInfo {
        let weatherInfo = try decoder.decode(WeatherInfo.self, from: Data(json.utf8))
        return weatherInfo
    }
}

// MARK: AreaWeatherList

struct AreaWeatherListRequestGenerator {
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    
    func generate(areas: [String], date: Date) throws -> String {
        let areaDateJSONData = try encoder.encode(AreasDate(areas: areas, date: date))
        let areasDateJSON = String(data: areaDateJSONData, encoding: .utf8)
        
        guard let areasDateJSON else {
            throw JSONError.failedToStringify
        }
        return areasDateJSON
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

    private struct AreasDate: Encodable {
        let areas: [String]
        let date: Date
    }
}

struct AreaWeatherListGenerator {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func generate(from json: String) throws -> [AreaWeather] {
        let areaWeather = try decoder.decode([AreaWeather].self, from: Data(json.utf8))
        return areaWeather
    }
}
