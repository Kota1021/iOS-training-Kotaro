//
//  LayoutPrototype.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI

struct LayoutPrototype: View {
    let weatherAPI = WeatherAPIClient()
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

    var body: some View {
        GeometryReader { geometry in

            let imageSideLength = geometry.size.width / 2
            let temperatureWidth = geometry.size.width / 4
            let buttonWidth = geometry.size.width / 4

            VStack(alignment: .center, spacing: .zero) {
                if let weatherCondition = weatherInfo?.weatherCondition {
                    weatherCondition.icon
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(weatherCondition.color)
                        .frame(width: imageSideLength,
                               height: imageSideLength)
                } else {
                    Image(systemName: "exclamationmark.square.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray)
                        .frame(width: imageSideLength,
                               height: imageSideLength)
                }

                HStack(spacing: .zero) {
                    Text(weatherInfo != nil ? "\(weatherInfo!.minTemperature)" : "--")
                        .foregroundStyle(.blue)
                        .frame(width: temperatureWidth)
                    Text(weatherInfo != nil ? "\(weatherInfo!.maxTemperature)" : "--")
                        .foregroundStyle(.red)
                        .frame(width: temperatureWidth)
                }
                .padding(.bottom, 80)

                HStack(spacing: .zero) {
                    Button("Close") {}
                        .frame(width: buttonWidth)
                    Button("Reload") {
                        print("reload tapped")
                        weatherFetchResult = weatherAPI.fetchWeatherCondition(in: "tokyo", at: Date())
                    }
                    .frame(width: buttonWidth)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
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
    LayoutPrototype()
}
