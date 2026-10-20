//
//  ExportIconManager.swift
//
//  Created on 14.11.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Foundation

/// Protocol defining the requirements for exporting icons.
public protocol ExportIconManagerProtocol {
    /// Indicates whether exporting is currently allowed.
    var canExport: Bool { get }

    var askTips: Bool { get }

    /// Exports the given image.
    /// - Parameter image: The `ImageDto` object containing information about the image to be exported.
    func export(image: ImageDto)
}

/// Manages the export of icons, including handling the export count and interacting with the icon manager.
final class ExportIconManager: ExportIconManagerProtocol {
    /// The settings related to the application, including export count.
    var appSettings: AppSettingsProtocol

    /// The manager responsible for converting images to ICNS format and setting icons.
    let iconManager: IconManager

    /// Initializes a new instance of `ExportIconManager`.
    /// - Parameters:
    ///   - appSettings: The settings object used for managing export-related settings.
    ///   - iconManager: The manager responsible for converting images and setting icons. Defaults to a new instance of `IconManager`.
    init(appSettings: AppSettingsProtocol, iconManager: IconManager = .init()) {
        self.appSettings = appSettings
        self.iconManager = iconManager
    }

    /// Indicates whether exporting is allowed. Returns `true` if there are remaining exports or if full access is granted; otherwise, `false`.
    var canExport: Bool {
        true
    }

    var askTips: Bool {
        appSettings.exportCount == 5 && appSettings.tipped.value == "0"
    }

    /// Exports the given image by converting it to ICNS format and setting it at the specified URL.
    /// - Parameter image: The `ImageDto` object containing information about the image to be exported.
    func export(image: ImageDto) {
        guard let url = image.url else {
            return
        }

        do {
            let icnsData = try iconManager.convertImagesToIcns(image.outputImages)
            try iconManager.setIcon(data: icnsData, to: url)
        } catch {
            return
        }

        appSettings.exportCount += 1
    }
}

/// A preview implementation of `ExportIconManagerProtocol` used for testing or development purposes.
final class ExportIconManagerPreview: ExportIconManagerProtocol {
    /// Always returns `false`, indicating that exporting is not allowed in the preview.
    var canExport: Bool {
        false
    }

    var askTips: Bool {
        false
    }

    /// No operation is performed in the preview implementation.
    /// - Parameter image: The `ImageDto` object containing information about the image to be exported.
    func export(image _: ImageDto) {}
}
