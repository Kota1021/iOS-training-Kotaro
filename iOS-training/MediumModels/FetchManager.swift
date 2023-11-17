//
//  FetchManager.swift
//  FetchManager
//
//  Created by 松本 幸太郎 on 2023/10/13.
//

import Foundation

@Observable
class FetchManager<Product> {
    init(for process: @escaping () throws -> Product) {
        self.process = process
    }
    
    private var process: () throws -> Product
    
    var fetched: Product? {
        if case let .succeeded(weatherDateTemperature) = fetchState {
            weatherDateTemperature
        } else {
            nil
        }
    }

    var error: Error? {
        if case let .failed(error) = fetchState {
            error
        } else {
            nil
        }
    }

    private var fetchState: FetchState = .initial
    private enum FetchState {
        case initial
        case succeeded(Product)
        case failed(Error)
    }

    func fetch() {
            do {
                let weatherDateTemperature = try process()
                fetchState = .succeeded(weatherDateTemperature)
            } catch {
                fetchState = .failed(error)
            }
    }

    func reset() {
        fetchState = .initial
    }
}
