//
//  DropFolderViewConstants.swift
//
//  Created on 05.11.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit

enum DropFolderViewConstants {
    /// A system icon representing a folder with a plus badge.
    /// - Returns: An `NSImage` configured with a green and gray palette.
    static var icon: NSImage {
        // Attempt to create the system symbol image
        guard let image = NSImage(systemSymbolName: "folder.badge.plus", accessibilityDescription: nil) else {
            // Fallback or handle error if image creation fails
            return NSImage()
        }

        // Create the symbol configuration
        var config = NSImage.SymbolConfiguration(textStyle: .body, scale: .large)
        config = config.applying(.init(paletteColors: [.systemGreen, .systemGray]))

        // Apply the symbol configuration to the image
        return image.withSymbolConfiguration(config) ?? NSImage()
    }
}
