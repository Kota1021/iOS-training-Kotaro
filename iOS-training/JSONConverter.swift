//
//  WeatherDateTemperature.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/12.
//

import Foundation

//MARK: -input

struct AreaDate{
//    Example
//    {
//        "area": "tokyo",
//        "date": "2020-04-01T12:00:00+09:00"
//    }
    let area: String
    let date: CustomDate
}




//MARK: -output
struct WeatherDateTemperature{
//    Example
//    {
//        "max_temperature":25,
//        "date":"2020-04-01T12:00:00+09:00",
//        "min_temperature":7,
//        "weather_condition":"cloudy"
//    }
    let max_temperature:Int
    let date:CustomDate
    let min_temperature:Int
    let weather_condition:Weather
}


///2020-04-01T12:00:00+09:00
struct CustomDate{
    
    let year:Int
    let month:Int
    let day:Int
    let hour:Int
    let minute:Int
    let second:Int
    let hourDifFromGMT:Int
    let minuteDifFromGMT:Int
    
    var string:String{ "\(year)-\(month)-\(day)T\(hour):\(minute):\(second)+\(hourDifFromGMT):\(minuteDifFromGMT)" }
}

