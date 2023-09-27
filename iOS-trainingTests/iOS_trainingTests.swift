//
//  iOS_trainingTests.swift
//  iOS-trainingTests
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

@testable import iOS_training
import XCTest

final class iOS_trainingTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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

        do {
            _ = try WeatherDateTemperatureDecoder().generateWeatherDateTemperature(from: inputJSON)
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
