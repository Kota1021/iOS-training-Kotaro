//
//  ContentView.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI

struct ContentView: View {
    private let weatherAPI: WeatherAPI
    
    @State private var fetchedWeather: FetchedWeather = .initial
    
    private var weatherInfo: WeatherDateTemperature? {
        if case let .succeeded(weatherDateTemperature) = fetchedWeather {
            weatherDateTemperature
        } else {
            nil
        }
    }

    private var minTemperature: String {
        (weatherInfo?.minTemperature).map(String.init) ?? "--"
    }

    private var maxTemperature: String {
        (weatherInfo?.maxTemperature).map(String.init) ?? "--"
    }

    private var error: Error? {
        if case let .failed(error) = fetchedWeather {
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
            // Setting WeatherIcon to be square
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / 2
                }
                .overlay {
                    WeatherIcon(weatherInfo?.weatherCondition)
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
                Button("Close") {
                    /* https://github.com/yumemi-inc/ios-training/blob/main/Documentation/VC_Lifecycle.md
                     SwiftUIで「UIViewControllerのライフサイクルの動作を確認する」ことに相当するような実装が思いつかなかったためスキップ */
                }
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
                if !isPresented { fetchedWeather = .initial }
            }
        )) { /* Buttons */ } message: {
            Text(error?.localizedDescription ?? "__")
        }
    }

    func fetchWeather() {
        let result = weatherAPI.fetchWeatherCondition(in: "tokyo", at: Date())
        do {
            let weatherDateTemperature = try result.get()
            fetchedWeather = .succeeded(weatherDateTemperature)
        } catch {
            fetchedWeather = .failed(error)
        }
    }

    enum FetchedWeather {
        case initial
        case succeeded(WeatherDateTemperature)
        case failed(Error)
    }
}

#Preview {
    ContentView(weatherAPI: WeatherAPIStub())
}
