//
//  AreaWeatherRow.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/10/11.
//

import SwiftUI

struct AreaWeatherRow: View {
    init(_ areaWeather: AreaWeather) {
        self.areaWeather = areaWeather
    }

    let areaWeather: AreaWeather

    var body: some View {
        HStack {
            WeatherIcon(areaWeather.info.weatherCondition)
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / 10
                }
            Text(areaWeather.area)
            Spacer()
            Text("\(areaWeather.info.minTemperature)")
            Text("\(areaWeather.info.maxTemperature)")
        }
    }
}

#Preview {
    AreaWeatherRow(WeatherAPIStub.areaWeather)
}
