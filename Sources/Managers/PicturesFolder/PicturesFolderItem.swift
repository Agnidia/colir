//
//  PicturesFolderItem.swift
//
//  Created on 07.10.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit

/// A struct representing an item in the "Pictures" folder.
///
/// This struct contains the name of the image file and the `NSImage` object for the image.
struct PicturesFolderItem {
    /// The name of the image file.
    let name: String

    /// The `NSImage` object representing the image.
    let image: NSImage

    /// Initializes a `PicturesFolderItem` with the provided name and image.
    ///
    /// - Parameters:
    ///   - name: The name of the image file.
    ///   - image: An optional `NSImage` object. If `nil`, the initialization will fail.
    /// - Returns: An initialized `PicturesFolderItem` if the image is not `nil`, otherwise `nil`.
    init?(name: String, image: NSImage?) {
        guard let image else { return nil }
        self.name = name
        self.image = image
    }
}

extension PicturesFolderItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}
