//
//  ContentView.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI

struct ContentView: View {
    init(weatherFetchManager: FetchTaskManager<[AreaWeather]>) {
        _weatherFetchManager = State(initialValue: weatherFetchManager)
    }

    @State private var weatherFetchManager: FetchTaskManager<[AreaWeather]>
    private var areaWeatherList: [AreaWeather] {
        weatherFetchManager.fetched ?? []
    }

    private var isFetching: Bool {
        weatherFetchManager.isFetching
    }

    private var error: Error? {
        weatherFetchManager.error
    }

    private var errorMessage: String {
        error?.localizedDescription ?? "__"
    }

    var body: some View {
        NavigationStack {
            VStack {
                List(areaWeatherList) { areaWeather in
                    NavigationLink(value: areaWeather) {
                        AreaWeatherRow(areaWeather)
                    }
                }
            
                // TODO: when pulling to reflesh, hide overlayed ProgressView
                .refreshable { weatherFetchManager.fetch() }
                .navigationDestination(for: AreaWeather.self) { areaWeather in
                    AreaWeatherDetail(weatherInfo: areaWeather.info)
                        .navigationTitle(areaWeather.area)
                }
                .navigationTitle("Cities")
                .navigationBarTitleDisplayMode(.large)
        
                HStack(spacing: .zero) {
                    Button("Close") {
                        /* https://github.com/yumemi-inc/ios-training/blob/main/Documentation/VC_Lifecycle.md
                         SwiftUIで「UIViewControllerのライフサイクルの動作を確認する」ことに相当するような実装が思いつかなかったためスキップ */
                    }
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 4
                    }
                    Button("Reload") {
                        weatherFetchManager.fetch()
                    }
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 4
                    }
                }
            }
            .overlay {
                if isFetching {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.ultraThinMaterial)
                        }
                }
            }
            .alert("Error", isPresented: .constant(error != nil)) {
                Button("YES") {
                    weatherFetchManager.reset()
                    weatherFetchManager.fetch()
                }
            } message: {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    let fetchingMethod = { try await WeatherAPIStub().fetchWeatherList(in: [], at: Date()) }
    return ContentView(weatherFetchManager: FetchTaskManager(for: fetchingMethod))
}
