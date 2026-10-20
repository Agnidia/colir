//
//  LogProtocol.swift
//
//  Created on 10.10.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import Foundation

/// `LogProtocol` provides structure for logging
protocol LogProtocol {
    /// Logs a debug message.
    /// - Parameter message: The message to be logged.
    func debug(_ message: String)

    /// Logs an informational message.
    /// - Parameter message: The message to be logged.
    func info(_ message: String)

    /// Logs an error message.
    /// - Parameter message: The message to be logged.
    func error(_ message: String)
}
