//
//  NSOpenPanel+DirPermissions.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 01.05.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension NSOpenPanel {
    private enum K {
        static let promptButton = "Choose"
    }
    
    /// Prompts the user to grant access to a specific directory.
    /// - Parameters:
    ///   - dir: The initial URL of the directory to prompt for access.
    ///   - message: The message to display in the open panel.
    /// - Returns: The URL of the directory if access is granted; otherwise, `nil`.
    static func promptPermission(to dir: URL, message: String) -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.message = message
        openPanel.prompt = K.promptButton
        openPanel.allowedContentTypes = []
        openPanel.allowsOtherFileTypes = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.directoryURL = dir

        let _ = openPanel.runModal()
        return openPanel.urls.first
    }
}
