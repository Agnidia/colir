//
//  Logger.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import Foundation
import os.log

/// `Log` is a utility structure that provides structured logging functionalities
/// to facilitate easy debugging and error tracking in various components of the application.
///
/// It leverages Apple's unified logging system to categorize and filter logs efficiently.
struct Log {
    /// `Category` enumerates the various categories or components in the application for which
    /// logging can be performed, aiding in the categorization and filtering of logs.
    ///
    /// - application: General application lifecycle logs.
    /// - fileStorage: Logs detailing file system operations.
    /// - photoAppAccess: Logs for communication with Photos app.
    ///
    enum Category: String {
        case ui
        case application
        case fileStorage
        case photoAppAccess
        case photoLibrary
        case toolsPhoto
        case home
        case appStore
        case imageProcessing
    }

    /// The subsystem for the logs, which utilizes the main bundle identifier
    /// of the application to namespace the logs, enhancing their traceability and filtering.
    private static let subsystem = Bundle.main.bundleIdentifier!

    /// The `Logger` instance derived from the OS logging system, configured for a specific logging category.
    private let logger: Logger

    /// The specific category for which this `Log` instance is configured.
    private let category: Category

    /// Initializes a new `Log` instance configured for a specific logging category.
    ///
    /// - Parameter category: The category for which the logging is to be performed.
    init(category: Category) {
        logger = Logger(subsystem: Log.subsystem, category: category.rawValue)
        self.category = category
    }

    /// display execution time in seconds  of function
    func elapsedTime(startAt: CFAbsoluteTime, finishAt: CFAbsoluteTime = CFAbsoluteTimeGetCurrent(), file: String = #fileID, function: String = #function) {
        var path = file
        if let f = file.split(separator: "/").last, let fileName = f.split(separator: ".").first {
            path = String(fileName)
        }

        logger.info("[\(path): \(function)] execution took: \(finishAt - startAt)s")
    }
}

extension Log {
    /// A dictionary mapping logging categories to boolean values, which dictate
    /// whether logging is enabled or disabled for each category.
    static var enabledList: [Category: Bool] {
        [
            .ui: false,
            .application: false,
            .fileStorage: false,
            .photoAppAccess: false,
            .photoLibrary: false,
            .toolsPhoto: false,
            .home: false,
            .appStore: true,
            .imageProcessing: false,
        ]
    }
}

extension Log: LogProtocol {
    /// Logs a debug message if logging is enabled for the category of the `Log` instance.
    ///
    /// - Parameter message: The debug message to be logged.
    func debug(_ message: String) {
        guard Self.enabledList[category] == true else {
            return
        }

        logger.debug("\(message, privacy: .public)")
    }

    /// Logs an informational message if logging is enabled for the category of the `Log` instance.
    ///
    /// - Parameter message: The informational message to be logged.
    func info(_ message: String) {
        guard Self.enabledList[category] == true else {
            return
        }

        logger.info("\(message, privacy: .public)")
    }

    /// Logs an error message if logging is enabled for the category of the `Log` instance.
    ///
    /// - Parameter message: The error message to be logged.
    func error(_ message: String) {
        guard Self.enabledList[category] == true else {
            return
        }

        logger.error("\(message, privacy: .public)")
    }
}
