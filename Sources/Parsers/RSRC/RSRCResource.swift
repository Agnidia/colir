//
//  RSRCResource.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit

/// A class representing a resource that may contain data and can be used to generate an `NSImage`.
///
/// This class is used to encapsulate a resource, providing access to its underlying data and
/// the ability to create an `NSImage` from that data if applicable.
final class RSRCResource: NSObject {
    /// The data associated with this resource.
    ///
    /// This property holds the raw data of the resource. It can be used to initialize an `NSImage`
    /// if the data represents image data.
    var data: Data

    /// The `NSImage` representation of the resource, if possible.
    ///
    /// This computed property attempts to create an `NSImage` from the resource's data.
    /// If the `data` property is `nil` or if the data cannot be converted to an `NSImage`,
    /// this property will return `nil`.
    var image: NSImage? {
        NSImage(data: data)
    }

    /// Initializes a new `RSRCResource` with optional data.
    ///
    /// - Parameter data: The data to initialize the resource with. If `nil`, the resource will be
    ///                   initialized with no data.
    @objc
    init(data: Data) {
        self.data = data
    }
}
