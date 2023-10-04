//
//  ContentView.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI

struct ContentView: View {
    let weatherAPI: WeatherAPI
    @State private var fetchState: FetchState = .beforeFetch

    var weatherInfo: WeatherDateTemperature? {
        if case let .succeeded(weatherDateTemperature) = fetchState {
            weatherDateTemperature
        } else {
            nil
        }
    }

    var minTemperature: String {
        if let weatherInfo {
            String(weatherInfo.minTemperature)
        } else {
            "--"
        }
    }

    var maxTemperature: String {
        if let weatherInfo {
            String(weatherInfo.maxTemperature)
        } else {
            "--"
        }
    }

    var error: Error? {
        if case let .failed(error) = fetchState {
            error
        } else {
            nil
        }
    }

    init(weatherAPI: WeatherAPI) {
        self.weatherAPI = weatherAPI
    }

    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            WeatherIcon(weatherInfo?.weatherCondition)
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / 2
                }

            HStack(spacing: .zero) {
                Text(minTemperature)
                    .foregroundStyle(.blue)
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 4
                    }
                Text(maxTemperature)
                    .foregroundStyle(.red)
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 4
                    }
            }
            .padding(.bottom, 80)

            HStack(spacing: .zero) {
                Button("Close") {}
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 4
                    }
                Button("Reload") {
                    fetchWeather()
                }
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / 4
                }
            }
        }
        .onAppear {
            fetchWeather()
        }
        .alert("Error", isPresented: Binding(
            get: { error != nil },
            set: { isPresented in
                if !isPresented { fetchState = .beforeFetch }
            }
        )) { /* Buttons */ } message: {
            Text(error?.localizedDescription ?? "__")
        }
    }

    func fetchWeather() {
        fetchState = .fetching
        let result = weatherAPI.fetchWeatherCondition(in: "tokyo", at: Date())
        do {
            let weatherDateTemperature = try result.get()
            fetchState = .succeeded(weatherDateTemperature)
        } catch {
            fetchState = .failed(error)
        }
        print(fetchState)
    }
}

enum FetchState {
    case beforeFetch
    case fetching
    case succeeded(WeatherDateTemperature)
    case failed(Error)
}

#Preview {
    ContentView(weatherAPI: WeatherAPIStub())
}
