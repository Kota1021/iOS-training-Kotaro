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

    var errorAlertIsPresented: Bool {
        switch weatherFetchResult {
        case .failure:
            return true
        default:
            return false
        }
    }

    var body: some View {
        GeometryReader { geometry in

            let imageSideLength = geometry.size.width / 2
            let temperatureWidth = geometry.size.width / 4
            let buttonWidth = geometry.size.width / 4

            VStack(alignment: .center, spacing: .zero) {
                switch weatherFetchResult {
                case .none:
                    EmptyView()
                case .success(let weatherDateTemperature):
                    weatherDateTemperature.weatherCondition.icon
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(weatherDateTemperature.weatherCondition.color)
                        .frame(width: imageSideLength,
                               height: imageSideLength)
                case .failure:
                    Image(systemName: "exclamationmark.square.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray)
                        .frame(width: imageSideLength,
                               height: imageSideLength)
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
                        print("reload tapped")
                        weatherFetchResult = self.fetchWeatherCondition(at: "tokyo")
                    }
                    .frame(width: buttonWidth)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .alert("Error", isPresented: Binding(
            get: { errorAlertIsPresented },
            set: { isPresented in
                if !isPresented { weatherFetchResult = nil }
            }
        )) { /* Buttons */ } message: {
            if case let .failure(error) = weatherFetchResult {
                Text(error.localizedDescription)
            }
        }
    }

    func fetchWeatherCondition(at area: String) -> Result<WeatherDateTemperature, Error> {
        print("fetchWeatherCondition called")
        do {
            //MARK: Encoding into JSON
            let areaDate = AreaDate(area: area, date: Date())
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
