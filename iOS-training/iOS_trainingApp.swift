//
//  iOS_trainingApp.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI

@main
struct iOS_trainingApp: App {
    private let weatherFetchManager: FetchManager<WeatherDateTemperature> = {
        let fetchingMethod = { try WeatherAPIImpl().fetchWeatherCondition(in: "tokyo", at: Date()) }
        return FetchManager(for: fetchingMethod)
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(weatherFetchManager: weatherFetchManager)
        }
    }
}
