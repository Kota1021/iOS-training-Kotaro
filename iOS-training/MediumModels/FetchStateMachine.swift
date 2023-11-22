//
//  FetchStateMachine.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/10/20.
//

import Foundation

struct FetchStateMachine<Success, Failure> where Failure: Error {
    private(set) var state: FetchState = .initial
    private var result: Result<Success, Failure>?
    
    var product: Success? {
        try? result?.get()
    }
    
    var error: Failure? {
        if case let .failure(e) = result {
            e
        } else {
            nil
        }
    }
    
    mutating func start() { state = .isFetching }
    mutating func stop() { state = result == nil ? .initial : .fetched }
    
    mutating func finish(with value: Result<Success, Failure>) {
        result = value
        state = .fetched
    }
    
    mutating func reset() {
        result = nil
        state = .initial
    }
}

enum FetchState {
    case initial
    case isFetching
    case fetched
}
