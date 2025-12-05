//
//  NSImage+Data.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 05.05.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension NSBitmapImageRep {
    /// Converts the bitmap image representation to PNG data.
    ///
    /// - Returns: A `Data` object containing the PNG representation of the image, or `nil` if the conversion fails.
    var pngData: Data? {
        representation(using: .png, properties: [:])
    }
}

extension Data {
    /// Creates an `NSBitmapImageRep` from the data.
    ///
    /// - Returns: An `NSBitmapImageRep` object if the data can be interpreted as an image, or `nil` otherwise.
    var bitmap: NSBitmapImageRep? {
        NSBitmapImageRep(data: self)
    }
}

extension NSImage {
    /// Converts the image to PNG data.
    ///
    /// - Returns: A `Data` object containing the PNG representation of the image, or `nil` if the conversion fails.
    var pngData: Data? {
        tiffRepresentation?.bitmap?.pngData
    }
}
