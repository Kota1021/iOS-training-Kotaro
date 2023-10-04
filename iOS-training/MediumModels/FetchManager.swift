//
//  FetchManager.swift
//  FetchManager
//
//  Created by 松本 幸太郎 on 2023/10/13.
//

import Foundation

@Observable
class FetchManager<Product> {
    init(for process: @escaping () async throws -> Product) {
        self.process = process
    }
    
    private var process: () async throws -> Product
    
    private var task: Task<Void, Never>? {
        willSet { task?.cancel() }
    }
    
    private(set) var isFetching = false

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
        task = Task {
            isFetching = true
            do {
                let product = try await process()
                guard !Task.isCancelled else {
                    isFetching = false
                    return
                }
                fetchState = .succeeded(product)
            } catch {
                guard !Task.isCancelled else {
                    isFetching = false
                    return
                }
                fetchState = .failed(error)
            }
            isFetching = false
        }
    }

    func reset() {
        fetchState = .initial
    }
}
