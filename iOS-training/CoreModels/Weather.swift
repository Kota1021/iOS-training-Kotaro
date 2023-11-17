//
//  Weather.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/12.
//

enum Weather: String, Decodable {
    case sunny
    case cloudy
    case rainy
}

// Conform to CaseIterable to pick a random element for Preview
extension Weather: CaseIterable {}
