//
//  AreaWeatherDetail.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/10/06.
//

import SwiftUI

struct AreaWeatherDetail: View {
    let weatherInfo: WeatherInfo
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            WeatherIcon(weatherInfo.weatherCondition)
                .containerRelativeFrame([.horizontal, .vertical]) { length, _ in
                    length / 2
                }
            HStack(spacing: .zero) {
                Text("\(weatherInfo.minTemperature)")
                    .foregroundStyle(.blue)
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 4
                    }
                Text("\(weatherInfo.maxTemperature)")
                    .foregroundStyle(.red)
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 4
                    }
            }
            .padding(.bottom, 80)
        }
    }
}

#Preview {
    AreaWeatherDetail(weatherInfo: WeatherAPIStub.weatherInfo)
}
