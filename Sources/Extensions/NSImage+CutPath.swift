//
//  NSImage+CutPath.swift
//
//  Created on 08.11.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit

extension NSImage {
    /// Cuts the image using the specified bezier path.
    ///
    /// This function creates a new image by applying a clipping path to the original image. The resulting image will only show the part of the original image that falls within the path.
    ///
    /// - Parameter path: The `NSBezierPath` used to clip the image.
    /// - Returns: A new `NSImage` that has been clipped by the specified path.
    func cutImage(by path: NSBezierPath) -> NSImage {
        let size = size

        // Create an NSImage of the same size as the original image
        let cutImage = NSImage(size: size)

        // Begin drawing in the cutImage
        cutImage.lockFocus()

        // Create a clipping path using NSBezierPath
        let clippingPath = path
        clippingPath.windingRule = .evenOdd

        // Add the clipping path to the graphics context
        clippingPath.addClip()

        // Draw the original image into the cutImage
        draw(in: NSRect(origin: .zero, size: size))

        // End drawing in the cutImage
        cutImage.unlockFocus()

        return cutImage
    }
}
