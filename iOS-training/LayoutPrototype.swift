//
//  LayoutPrototype.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI
import YumemiWeather

struct LayoutPrototype: View {
    @State var fetchedWeather: Weather? = nil

    var body: some View {
        GeometryReader { geometry in

            let imageSideLength = geometry.size.width / 2
            let temperatureWidth = geometry.size.width / 4
            let buttonWidth = geometry.size.width / 4

            VStack(alignment: .center, spacing: .zero) {
                switch fetchedWeather {
                case .sunny:
                    Image(.iconsun)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.red)
                        .frame(width: imageSideLength, height: imageSideLength)
                case .cloudy:
                    Image(.iconclouds)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray)
                        .frame(width: imageSideLength, height: imageSideLength)
                case .rainy:
                    Image(.iconumbrella)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.blue)
                        .frame(width: imageSideLength, height: imageSideLength)
                case .none:
                    Image(systemName: "exclamationmark.square.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray)
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
}
