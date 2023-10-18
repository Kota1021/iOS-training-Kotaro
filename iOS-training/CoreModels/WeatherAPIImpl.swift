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
        // Making Encodable Object
        struct AreaDate: Encodable {
            let area: String
            let date: Date
        }
        
        let areaDate = AreaDate(area: area, date: date)
        let requestJSON = try JSONGenerator().generate(from: areaDate)
        let fetchedWeatherJSON = try await YumemiWeather.asyncFetchWeather(requestJSON) // may throw YumemiWeatherError.invalidParameterError and \.unknownError
        let weatherInfo: WeatherInfo = try ObjectGenerator().generate(from: fetchedWeatherJSON)
        return weatherInfo
    }

    func fetchWeatherList(in areas: [String], at date: Date) async throws -> [AreaWeather] {
        // Making Encodable Object
        struct AreasDate: Encodable {
            let areas: [String]
            let date: Date
        }
        
        let areasDate = AreasDate(areas: areas, date: date)
        let requestJSON = try JSONGenerator().generate(from: areasDate)
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

// internal for test
struct JSONGenerator {
    func generate(from object: some Encodable) throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.outputFormatting = .sortedKeys
        
        let data = try encoder.encode(object)
        let json = String(data: data, encoding: .utf8)
        
        guard let json else {
            throw JSONError.failedToStringify
        }
        return json
    }
    
    enum JSONError: Error, LocalizedError {
        case failedToStringify
        var errorDescription: String? {
            switch self {
            case .failedToStringify: "failed to stringify JSON"
            }
        }
    }
}
