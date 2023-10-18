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
        let weatherInfo: WeatherInfo = try ObjectGenerator().generate(from: fetchedWeatherJSON)
        return weatherInfo
    }

    func fetchWeatherList(in areas: [String], at date: Date) async throws -> [AreaWeather] {
        let requestJSON = try AreaWeatherListRequestGenerator().generate(areas: areas, date: date)
        let fetchedWeatherListJSON = try await YumemiWeather.asyncFetchWeatherList(requestJSON)
        let areaWeatherList: [AreaWeather] = try ObjectGenerator().generate(from: fetchedWeatherListJSON)
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

// internal for test
struct ObjectGenerator {
    func generate<Object: Decodable>(from json: String) throws -> Object {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
            
        let object = try decoder.decode(Object.self, from: Data(json.utf8))
        return object
    }
}

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
