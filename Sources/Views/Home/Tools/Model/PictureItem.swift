//
//  PictureItem.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

/// A model representing an item with an image, name, and associated tags.
///
/// The `PictureItem` struct holds information about a picture item, including its name,
/// associated tags, and the image itself. Each item has a unique identifier and can be used
/// for displaying or managing pictures in the application.
///
/// - Properties:
///   - `id`: A unique identifier for the item (UUID).
///   - `name`: The name of the picture item.
///   - `tags`: An array of tags associated with the picture item.
///   - `image`: The image associated with the picture item, represented by an `NSImage`.
struct PictureItem: Identifiable, Hashable {
    let id = UUID()
    
    let name: String
    
    let tags: [String]
    
    let image: NSImage
}

extension PictureItem: Equatable {
    /// Compares two `PictureItem` instances for equality.
    ///
    /// Two `PictureItem` instances are considered equal if their `name` and `tags` properties are equal.
    ///
    /// - Parameters:
    ///   - lhs: The first `PictureItem` instance.
    ///   - rhs: The second `PictureItem` instance.
    /// - Returns: `true` if both instances have the same `name` and `tags`; otherwise, `false`.
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.tags == rhs.tags
    }
}
