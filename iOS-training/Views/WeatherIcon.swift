//
//  WeatherIcon.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/14.
//

import SwiftUI

struct WeatherIcon: View {
    let icon: Image
    let color: Color

    init(_ weather: Weather?) {
        (icon, color) = switch weather {
        case .sunny:
            (Image(.iconsun), .red)
        case .cloudy:
            (Image(.iconclouds), .gray)
        case .rainy:
            (Image(.iconumbrella), .blue)
        case .none:
            (Image(systemName: "exclamationmark.square.fill"), .gray)
        }
    }

    var body: some View {
        icon
            .resizable()
            .scaledToFit()
            .foregroundStyle(color)
    }
}
