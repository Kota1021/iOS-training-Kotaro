//
//  LayoutPrototype.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI
import YumemiWeather

struct LayoutPrototype: View {
    @State private var weatherFetchResult: Result<WeatherDateTemperature, Error>?

    var weatherInfo:WeatherDateTemperature?{
        switch weatherFetchResult{
        case .success(let weatherDateTemperature):
            return weatherDateTemperature
        default:
            return nil
        }
    }
    
    var error:Error?{
        switch weatherFetchResult{
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
//    var errorAlertIsPresented: Bool {
//        switch weatherFetchResult {
//        case .none:
//            return false
//        case .success:
//            return false
//        case .failure:
//            return true
//        }
//    }

    var body: some View {
        GeometryReader { geometry in

            let imageSideLength = geometry.size.width / 2
            let temperatureWidth = geometry.size.width / 4
            let buttonWidth = geometry.size.width / 4

            VStack(alignment: .center, spacing: .zero) {
                if let weatherInfo{
                    weatherInfo.weatherCondition.icon
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(weatherInfo.weatherCondition.color)
                        .frame(width: imageSideLength,
                               height: imageSideLength)
                }else{
                    Image(systemName: "exclamationmark.square.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray)
                        .frame(width: imageSideLength,
                               height: imageSideLength)
                }

                HStack(spacing: .zero) {
                    Text(weatherInfo != nil ?  "\(weatherInfo!.minTemperature)" : "--" )
                        .foregroundStyle(.blue)
                        .frame(width: temperatureWidth)
                    Text(weatherInfo != nil ?  "\(weatherInfo!.maxTemperature)" : "--" )
                        .foregroundStyle(.red)
                        .frame(width: temperatureWidth)
                }
                .padding(.bottom, 80)

                HStack(spacing: .zero) {
                    Button("Close") {}
                        .frame(width: buttonWidth)
                    Button("Reload") {
                        print("reload tapped")
                        weatherFetchResult = self.fetchWeatherCondition(in: "tokyo",at:Date())
                    }
                    .frame(width: buttonWidth)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .alert("Error", isPresented: Binding(
            get: { error != nil },
            set: { isPresented in
                if !isPresented { weatherFetchResult = nil }
            }
        )) { /* Buttons */ } message: {
            if case let .failure(error) = weatherFetchResult {
                Text(error.localizedDescription)
            }
        }
    }

    func fetchWeatherCondition(in area: String, at date:Date) -> Result<WeatherDateTemperature, Error>? {
        print("fetchWeatherCondition called")
        do {
            //MARK: Encoding into JSON
            let areaDate = AreaDate(area: area, date: date)
            let encoder: JSONEncoder = JSONEncoder()
            //FIXME: ISO8601をハードコーディングするのは気持ち悪い
            //しかし、dateEncodingStrategyでiso8601を指定すると最後にzが着く
            //c.f. https://qiita.com/m__ike_/items/81d84465bb4b9c470131
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            encoder.dateEncodingStrategy = .formatted(formatter)
            let areaDateJSON = try encoder.encode(areaDate)
            let areaDateJSONString = String(data: areaDateJSON, encoding: .utf8)!
            //MARK: Decoding from JSON
            let fetchedWeatherJSONString = try YumemiWeather.fetchWeather(areaDateJSONString)
            let fetchedWeatherJSON = fetchedWeatherJSONString.data(using: .utf8)!
            
            let decoder: JSONDecoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let weatherDateTemperature = try decoder.decode(WeatherDateTemperature.self, from: fetchedWeatherJSON)
            print("decoded")
            return .success(weatherDateTemperature)

        } catch let error as YumemiWeatherError {
            print("returned YumemiWeatherError")
            return .failure(error)
        } catch {
            print("returned Error")
            fatalError("LayoutPrototype: fetchWeatherCondition(at:) returned invalid error \(error)")
        }
    }
}

#Preview {
    LayoutPrototype()
}
