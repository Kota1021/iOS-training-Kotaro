//
//  Weather.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/12.
//

import SwiftUI
import YumemiWeather

enum Weather: String, Decodable {
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
