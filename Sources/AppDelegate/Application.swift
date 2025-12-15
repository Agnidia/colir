//
//  Application.swift
//
//  Created on 14.11.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Foundation

/// Handles application-level initialization and setup, including logging.
final class Application {
    // MARK: - Properties

    private let log: LogProtocol = Log(category: .application)

    // MARK: - Initialization

    /// Initializes the Application instance and logs the initialization.
    init() {
        log.info("Application initialized")
    }

    // MARK: - Setup

    /// Performs the main setup of base objects and logs the setup process.
    func setup() {
        log.info("Application setup started")
        // Add further setup logic here if needed.
    }
}
