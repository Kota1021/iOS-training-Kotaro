//
//  FetchTaskManager.swift
//  FetchTaskManager
//
//  Created by 松本 幸太郎 on 2023/10/13.
//

import Foundation

@Observable
class FetchTaskManager<Product> {
    init(for process: @escaping () async throws -> Product) {
        self.process = process
    }
    
    private var process: () async throws -> Product
    private var task: Task<Void, Never>? { willSet { task?.cancel() } }
    private var fetchStateMachine = FetchStateMachine<Product, Error>()
    
    var isFetching: Bool { fetchStateMachine.state == .isFetching }
    var fetched: Product? { fetchStateMachine.product }
    var error: Error? { fetchStateMachine.error }

    func fetch() {
        task = Task {
            fetchStateMachine.start()
            let result = await Result { try await process() }
            if Task.isCancelled {
                fetchStateMachine.stop()
                return
            }
            fetchStateMachine.finish(with: result)
        }
    }

    func reset() { fetchStateMachine.reset() }
}
