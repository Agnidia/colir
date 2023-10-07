//
//  NSOpenPanel+DirPermissions.swift
//  colir
//
//  Created by Vitalii P on 01.05.2023.
//

import AppKit

extension NSOpenPanel {
    private enum K {
        static let promptButton = "Choose"
    }
    
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
