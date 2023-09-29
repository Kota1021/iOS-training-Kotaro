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
    private let view: UIView = UIHostingController(rootView: LayoutPrototype(weatherAPI: WeatherAPIStub(.sunny))).view
    func testDefaultAppearance() {
        assertSnapshot(
            matching: view,
            as: .image(size: referenceSize)
        )
    }
}

private extension SwiftUI.View {
    func referenceFrame() -> some View {
        frame(width: referenceSize.width, height: referenceSize.height)
    }
}
