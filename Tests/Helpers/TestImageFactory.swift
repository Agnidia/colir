//
//  TestImageFactory.swift
//
//  Created on 03.01.2026.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Foundation

/// Factory for creating test images using CGContext (thread-safe, no lockFocus).
/// Sendable-compliant for parallel test execution.
enum TestImageFactory {
    /// Creates a solid color image using CGContext.
    /// - Parameters:
    ///   - size: The size of the image in points.
    ///   - color: The fill color (default: red).
    ///   - scale: The scale factor (default 1.0 for predictable pixel dimensions).
    /// - Returns: An NSImage filled with the specified color.
    static func solidColor(
        size: NSSize,
        color: NSColor = .red,
        scale: CGFloat = 1.0
    ) -> NSImage {
        let pixelWidth = Int(size.width * scale)
        let pixelHeight = Int(size.height * scale)

        guard pixelWidth > 0, pixelHeight > 0 else {
            return NSImage(size: size)
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: pixelWidth,
            height: pixelHeight,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return NSImage(size: size)
        }

        // Convert NSColor to CGColor
        context.setFillColor(color.cgColor)

        context.fill(CGRect(x: 0, y: 0, width: pixelWidth, height: pixelHeight))

        guard let cgImage = context.makeImage() else {
            return NSImage(size: size)
        }

        return NSImage(cgImage: cgImage, size: size)
    }

    /// Creates a transparent image with an optional colored region.
    /// - Parameters:
    ///   - size: The size of the image.
    ///   - fillRect: Optional rectangle to fill with color.
    ///   - fillColor: Color for the fill region (default: red with 50% alpha).
    /// - Returns: An NSImage with transparency.
    static func transparent(
        size: NSSize,
        fillRect: NSRect? = nil,
        fillColor: NSColor = NSColor.red.withAlphaComponent(0.5)
    ) -> NSImage {
        let pixelWidth = Int(size.width)
        let pixelHeight = Int(size.height)

        guard pixelWidth > 0, pixelHeight > 0 else {
            return NSImage(size: size)
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: pixelWidth,
            height: pixelHeight,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return NSImage(size: size)
        }

        // Fill with transparent
        context.clear(CGRect(x: 0, y: 0, width: pixelWidth, height: pixelHeight))

        // Optionally fill a region
        if let rect = fillRect {
            context.setFillColor(fillColor.cgColor)
            context.fillEllipse(in: rect)
        }

        guard let cgImage = context.makeImage() else {
            return NSImage(size: size)
        }

        return NSImage(cgImage: cgImage, size: size)
    }

    /// Creates a multi-region image (e.g., half red, half blue).
    /// Useful for tint testing.
    /// - Parameters:
    ///   - size: The size of the image.
    ///   - regions: Array of tuples containing rect and color for each region.
    /// - Returns: An NSImage with multiple colored regions.
    static func multiColor(
        size: NSSize,
        regions: [(rect: CGRect, color: NSColor)]
    ) -> NSImage {
        let pixelWidth = Int(size.width)
        let pixelHeight = Int(size.height)

        guard pixelWidth > 0, pixelHeight > 0 else {
            return NSImage(size: size)
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: pixelWidth,
            height: pixelHeight,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return NSImage(size: size)
        }

        for region in regions {
            context.setFillColor(region.color.cgColor)
            context.fill(region.rect)
        }

        guard let cgImage = context.makeImage() else {
            return NSImage(size: size)
        }

        return NSImage(cgImage: cgImage, size: size)
    }
}
