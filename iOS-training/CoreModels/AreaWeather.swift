//
//  AreaWeather.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/10/06.
//

import Foundation

struct AreaWeather: Decodable, Identifiable {
    // conform to Identifiable
    let id = UUID()

    // conform to Decodable
    let area: String
    let info: WeatherInfo
    
    enum CodingKeys: CodingKey {
        case area
        case info
    }
}

 extension AreaWeather: Hashable {}
