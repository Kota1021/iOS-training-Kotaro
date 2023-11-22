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

private let referenceSize = CGSize(width: 300, height: 300)

class LayoutPrototypeTests: XCTestCase {
    private let view: UIView = {
        // Setting up weatherFetchManager
        let fetchingMethod = { WeatherAPIStub().fetchWeatherCondition(of: .sunny) }
        let weatherFetchManager: FetchTaskManager<WeatherDateTemperature> = FetchTaskManager(for: fetchingMethod)
        weatherFetchManager.fetch()
        return UIHostingController(rootView: ContentView(weatherFetchManager: weatherFetchManager)).view
    }()
    
    func testDefaultAppearance() {
        assertSnapshot(
            of: view,
            as: .image(size: referenceSize),
            record: false // return true to make a new reference snapshot
        )
    }
}

private extension SwiftUI.View {
    func referenceFrame() -> some View {
        frame(width: referenceSize.width, height: referenceSize.height)
    }
}
