//
//  AsyncTestHelpers.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Combine
import Foundation
import Testing

/// Wait for a condition to become true with timeout
/// - Parameters:
///   - timeout: Maximum time to wait in seconds
///   - condition: Closure that returns true when condition is met
/// - Returns: True if condition was met, false if timeout occurred
@MainActor
func waitFor(
    timeout: TimeInterval = 5.0,
    condition: () -> Bool
) async -> Bool {
    let deadline = Date().addingTimeInterval(timeout)
    while Date() < deadline {
        if condition() { return true }
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms polling
    }
    return condition()
}

/// Wait for an async condition with timeout
/// - Parameters:
///   - timeout: Maximum time to wait in seconds
///   - condition: Async closure that returns true when condition is met
/// - Returns: True if condition was met, false if timeout occurred
func waitForAsync(
    timeout: TimeInterval = 5.0,
    condition: @escaping @Sendable () async -> Bool
) async -> Bool {
    let deadline = Date().addingTimeInterval(timeout)
    while Date() < deadline {
        if await condition() { return true }
        try? await Task.sleep(nanoseconds: 50_000_000)
    }
    return await condition()
}

/// Timeout error for async operations
struct TimeoutError: Error, LocalizedError {
    let timeout: TimeInterval

    var errorDescription: String? {
        "Operation timed out after \(timeout) seconds"
    }
}

/// Execute an async operation with timeout
/// - Parameters:
///   - timeout: Maximum time to wait in seconds
///   - operation: Async operation to execute
/// - Returns: Result of the operation
/// - Throws: TimeoutError if operation exceeds timeout
func withTimeout<T: Sendable>(
    _ timeout: TimeInterval,
    _ operation: @escaping @Sendable () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            try await operation()
        }

        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
            throw TimeoutError(timeout: timeout)
        }

        guard let result = try await group.next() else {
            throw TimeoutError(timeout: timeout)
        }

        group.cancelAll()
        return result
    }
}
