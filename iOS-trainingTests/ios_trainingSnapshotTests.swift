//
//  ios_trainingSnapshotTests.swift
//  iOS-trainingTests
//
//  Created by 松本 幸太郎 on 2023/09/29.
//

@testable import iOS_training
import SnapshotTesting
import SwiftUI
import XCTest

class LayoutPrototypeTests: XCTestCase {
    func testDefaultAppearance() {
        // Setting up weatherFetchManager
        let fetchingMethod = { try await WeatherAPIStub().fetchWeatherList(in: [], at: Date()) }
        let weatherFetchManager: FetchTaskManager<[AreaWeather]> = FetchTaskManager(for: fetchingMethod)
        weatherFetchManager.fetch()
        
        let targetView = ContentView(weatherFetchManager: weatherFetchManager)
        
        assertSnapshot(
            of: targetView,
            as: .image(layout: .device(config: .iPhone13)),
            record: false // return true to make a new reference snapshot
        )
    }
}
