//
//  AppCommons.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import Foundation

/// Provides general utility types and constants.
enum Commons {
    /// A closure with no parameters and no return value, typically used for callbacks with no data.
    typealias EmptyClosure = () -> Void

    /// A MainActor-isolated closure with no parameters and no return value.
    typealias MainActorEmptyClosure = @MainActor () -> Void
}

/// Enumerates the possible states for a SwiftUI view to represent different stages of a process.
enum StateMode: Int, CaseIterable {
    case idle // The view is in an idle state, no action is being performed.
    case progress // The view is showing progress, such as a loading spinner.
    case success // The view has successfully completed its task.
    case fault // The view encountered an error or fault.

    /// Provides a collection of all possible states.
    static var allCases: [StateMode] {
        [.idle, .progress, .success, .fault]
    }
}

/// Contains constants related to application secrets and configuration.
/// Replace the placeholder value with actual values as needed.
enum Secrets {
    // #error("setup secrets")
    static let userDefaultsId = "com.igrsoft.colir-defaults"
}
