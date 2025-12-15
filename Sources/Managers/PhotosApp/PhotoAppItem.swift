//
//  PhotoAppItem.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 08.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

/// A struct representing an item in the photo application, including its name and associated image.
struct PhotoAppItem {
    /// The name of the photo item.
    let name: String

    /// The image associated with the photo item.
    let image: NSImage

    /// Initializes a `PhotoAppItem` with a name and an optional image.
    /// - Parameters:
    ///   - name: The name of the photo item.
    ///   - image: The image associated with the photo item. If `nil`, initialization fails.
    /// - Returns: An optional `PhotoAppItem` instance. Returns `nil` if the image is `nil`.
    init?(name: String, image: NSImage?) {
        if let image {
            self.name = name
            self.image = image
        } else {
            return nil
        }
    }
}

extension PhotoAppItem: Equatable {
    /// Compares two `PhotoAppItem` instances for equality.
    /// - Parameters:
    ///   - lhs: The first `PhotoAppItem` instance.
    ///   - rhs: The second `PhotoAppItem` instance.
    /// - Returns: A Boolean value indicating whether the two `PhotoAppItem` instances have the same name.
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}
