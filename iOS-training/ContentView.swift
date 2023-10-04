//
//  ContentView.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI

struct ContentView: View {
    let weatherAPI: WeatherAPI
    @State private var weatherFetchResult: Result<WeatherDateTemperature, Error>?

    var weatherInfo: WeatherDateTemperature? {
        switch weatherFetchResult {
        case let .success(weatherDateTemperature):
            return weatherDateTemperature
        default:
            return nil
        }
    }

    var error: Error? {
        switch weatherFetchResult {
        case let .failure(error):
            return error
        default:
            return nil
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
                let (minTemperature, maxTemperature) = if let weatherInfo {
                    (String(weatherInfo.minTemperature),
                     String(weatherInfo.maxTemperature))
                } else {
                    ("--", "--")
                }

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
                    weatherFetchResult = weatherAPI.fetchWeatherCondition(in: "tokyo", at: Date())
                }
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / 4
                }
            }
        }
        .onAppear {
            weatherFetchResult = weatherAPI.fetchWeatherCondition(in: "tokyo", at: Date())
        }
        .alert("Error", isPresented: Binding(
            get: { error != nil },
            set: { isPresented in
                if !isPresented { weatherFetchResult = nil }
            }
        )) { /* Buttons */ } message: {
            if case let .failure(error) = weatherFetchResult {
                Text(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView(weatherAPI: WeatherAPIStub())
}
