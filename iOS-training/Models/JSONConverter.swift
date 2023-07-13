//
//  WeatherDateTemperature.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/12.
//

//c.f. https://medium.com/@bj1024/swift4-codable-json-encode-17eaa95372d1

import Foundation

//MARK: -input

struct AreaDate{
//    Example
//    {
//        "area": "tokyo",
//        "date": "2020-04-01T12:00:00+09:00"
//    }
    let area: String
    let date: Date
}
extension AreaDate: Encodable{}

func generateJSONStringFromAreaDate(_ areaDate: AreaDate)->String{
    let encoder: JSONEncoder = JSONEncoder()
    //FIXME: ISO8601をハードコーディングするのは気持ち悪い
    //しかし、dateEncodingStrategyでiso8601を指定すると最後にzが着く
    //c.f. https://qiita.com/m__ike_/items/81d84465bb4b9c470131
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    encoder.dateEncodingStrategy = .formatted(formatter)
    do{
        let areaDateJSON = try encoder.encode(areaDate)
        return String(data: areaDateJSON, encoding: .utf8)!
    }catch{
        fatalError("failed during generating areaDate \(error)")
    }
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
    let maxTemperature: Int
    let date: Date //ISO 8601
    let minTemperature: Int
    let weatherCondition: Weather

}
extension WeatherDateTemperature: Decodable{
    enum CodingKeys:String,CodingKey{
        case maxTemperature = "max_temperature"
        case date
        case minTemperature = "min_temperature"
        case weatherCondition = "weather_condition"
    }
}

//MARK: for testing

//let decoder: JSONDecoder = JSONDecoder()
//decoder.dateDecodingStrategy = .iso8601
//do {
//    let decoded: WeatherDateTemperature = try decoder.decode(WeatherDateTemperature.self, from: jsonString.data(using: .utf8)!)
//    print(decoded)
//} catch {
//    print(error.localizedDescription)
//}




