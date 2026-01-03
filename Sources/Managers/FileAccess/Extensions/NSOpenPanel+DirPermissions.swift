//
//  NSOpenPanel+DirPermissions.swift
//
//  Created on 07.10.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit

/// Errors that can occur when prompting for directory permission.
enum NSOpenPanelError: Error {
    /// The user cancelled the directory selection dialog.
    case userCancelled
}

extension NSOpenPanel {
    private enum K {
        static let promptButton = "Choose"
    }

    /// Prompts the user to grant access to a specific directory.
    /// - Parameters:
    ///   - dir: The initial URL of the directory to prompt for access.
    ///   - message: The message to display in the open panel.
    /// - Returns: The URL of the directory if access is granted.
    /// - Throws: `NSOpenPanelError.userCancelled` if the user cancels the dialog.
    static func promptPermission(to dir: URL, message: String) throws -> URL {
        let openPanel = NSOpenPanel()
        openPanel.message = message
        openPanel.prompt = K.promptButton
        openPanel.allowedContentTypes = []
        openPanel.allowsOtherFileTypes = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.directoryURL = dir

        let response = openPanel.runModal()

        guard response == .OK, let url = openPanel.urls.first else {
            throw NSOpenPanelError.userCancelled
        }
        return url
    }
}
