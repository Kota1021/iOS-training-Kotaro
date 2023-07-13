//
//  LayoutPrototype.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI
import YumemiWeather

struct LayoutPrototype: View {
    @State private var weatherFetchResult: Result<Weather,YumemiWeatherError>?

    var errorAlertIsPresented: Bool {
        switch weatherFetchResult {
        case .none:
            return false
        case .success(_):
            return false
        case .failure(_):
            return true
        }
    }

    var body: some View {
        GeometryReader { geometry in

            let imageSideLength = geometry.size.width / 2
            let temperatureWidth = geometry.size.width / 4
            let buttonWidth = geometry.size.width / 4

            VStack(alignment: .center, spacing: .zero) {
                
                switch weatherFetchResult {
                case .none:
                    EmptyView()
                case .success(let weather):
                    weather.icon
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(weather.color)
                        .frame(width: imageSideLength,
                               height: imageSideLength)
                case .failure(_):
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
            switch weatherFetchResult {
            case .none:
                EmptyView()
            case .success(_):
                EmptyView()
            case .failure(let errorDuringFetch):
                Text(errorDuringFetch.localizedDescription)
            }
        }
    }

    func fetchWeatherCondition(at area: String) -> Result<Weather,YumemiWeatherError> {
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
            return .failure(error)
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
