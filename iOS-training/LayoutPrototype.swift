//
//  LayoutPrototype.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI
import YumemiWeather

struct LayoutPrototype: View {
    @State private var fetchedWeather: Weather?

    var body: some View {
        GeometryReader { geometry in

            let imageSideLength = geometry.size.width / 2
            let temperatureWidth = geometry.size.width / 4
            let buttonWidth = geometry.size.width / 4

            VStack(alignment: .center, spacing: .zero) {
                if let fetchedWeather {
                    fetchedWeather.icon
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(fetchedWeather.color)
                        .frame(width: imageSideLength, height: imageSideLength)
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
                        let weather = YumemiWeather.fetchWeatherCondition()
                        // FIXME: Swift5.9からswitchで値を返せるはずだが、以下のようにクロージャで囲わないとビルドはできてもプレビューでCommand SwiftCompile failed...とエラー発生
                        fetchedWeather = {
                            switch weather {
                            case "sunny": .sunny
                            case "cloudy": .cloudy
                            case "rainy": .rainy
                            default: fatalError("invalid weather: \(weather)")
                            }
                        }()
                    }
                    .frame(width: buttonWidth)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
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
