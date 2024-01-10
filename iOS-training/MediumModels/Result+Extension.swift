//
//  Result+Extension.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/10/18.
//

import Foundation

extension Result where Failure == Swift.Error {
  public init(catching body: () async throws -> Success) async {
    do {
      self = try await .success(body())
    } catch {
      self = .failure(error)
    }
  }
}
