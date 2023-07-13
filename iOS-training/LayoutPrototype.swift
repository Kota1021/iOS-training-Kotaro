//
//  LayoutPrototype.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI
import YumemiWeather

struct LayoutPrototype: View {
    @State private var weatherFetchResult: WeatherFetchResult?

    var errorAlertIsPresented: Bool {
        if let weatherFetchResult,
           case WeatherFetchResult.failure = weatherFetchResult
        {
            return true
        } else {
            return false
        }
    }

    var body: some View {
        GeometryReader { geometry in

            let imageSideLength = geometry.size.width / 2
            let temperatureWidth = geometry.size.width / 4
            let buttonWidth = geometry.size.width / 4

            VStack(alignment: .center, spacing: .zero) {
                if let weatherFetchResult,
                   case let WeatherFetchResult.success(weather) = weatherFetchResult
                {
                    weather.icon
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(weather.color)
                        .frame(width: imageSideLength,
                               height: imageSideLength)

                } else if let weatherFetchResult,
                          case WeatherFetchResult.failure = weatherFetchResult
                {
                    Image(systemName: "exclamationmark.square.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray)
                        .frame(width: imageSideLength,
                               height: imageSideLength)
                }

                HStack(spacing: .zero) {
                    Text("--")
                        .foregroundStyle(.blue)
                        .frame(width: temperatureWidth)
                    Text("--")
                        .foregroundStyle(.red)
                        .frame(width: temperatureWidth)
                }
                .padding(.bottom, 80)

                HStack(spacing: .zero) {
                    Button("Close") {}
                        .frame(width: buttonWidth)
                    Button("Reload") {
                        weatherFetchResult = self.fetchWeatherCondition(at: "tokyo")
                    }
                    .frame(width: buttonWidth)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .alert("Error", isPresented: Binding(
                                        get: { errorAlertIsPresented },
                                        set: { isPresented in
                                            if !isPresented{ weatherFetchResult = nil }
                                        }
                                        )
                ) { /* Buttons */ } message: {
            if let weatherFetchResult,
               case let WeatherFetchResult.failure(errorDuringFetch) = weatherFetchResult
            {
                Text(errorDuringFetch.localizedDescription)
            } else {
                EmptyView()
            }
        }
    }

    func fetchWeatherCondition(at area: String) -> WeatherFetchResult {
        do {
            let weather: String = try YumemiWeather.fetchWeatherCondition(at: area)

            switch weather {
            case "sunny":
                return .success(.sunny)
            case "cloudy":
                return .success(.cloudy)
            case "rainy":
                return .success(.rainy)
            default: fatalError("LayoutPrototype: fetchWeatherCondition() returned an unintended weather of \(weather)")
            }

        } catch let error as YumemiWeatherError {
            return WeatherFetchResult.failure(error)
        } catch {
            fatalError("LayoutPrototype: fetchWeatherCondition(at:) returned invalid error \(error)")
        }
    }
}

#Preview {
    LayoutPrototype()
}

enum Weather {
    case sunny
    case cloudy
    case rainy

    var icon: Image {
        switch self {
        case .sunny:
            return Image(.iconsun)
        case .cloudy:
            return Image(.iconclouds)
        case .rainy:
            return Image(.iconumbrella)
        }
    }

    var color: Color {
        switch self {
        case .sunny:
            return .red
        case .cloudy:
            return .gray
        case .rainy:
            return .blue
        }
    }
}

enum WeatherFetchResult {
    case success(Weather)
    case failure(YumemiWeatherError)
}
