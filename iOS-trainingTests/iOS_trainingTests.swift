//
//  iOS_trainingTests.swift
//  iOS-trainingTests
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

@testable import iOS_training
import XCTest

final class iOS_trainingTests: XCTestCase {
    func test_WeatherRequestEncoder_generateRequestJSON() throws {
        let timeZone = TimeZone(abbreviation: "JST")!
        let inputDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: timeZone, year: 2020, month: 4, day: 1, hour: 12, minute: 0)
        let inputDate = inputDateComponents.date!

        let actualJSON = try WeatherRequestEncoder().generateRequestJSON(area: "tokyo", date: inputDate)
        let expectedJSON = #"{"area":"tokyo","date":"2020-04-01T12:00:00+09:00"}"#
        XCTAssertEqual(actualJSON, expectedJSON)
    }

    func test_WeatherDateTemperatureDecoder_generateWeatherDateTemperature() throws {
        let inputJSON = """
        {
            "max_temperature":25,
            "date":"2020-04-01T12:00:00+09:00",
            "min_temperature":7,
            "weather_condition":"cloudy"
        }
        """

        XCTAssertNoThrow(try WeatherDateTemperatureDecoder().generateWeatherDateTemperature(from: inputJSON))
    }
}
