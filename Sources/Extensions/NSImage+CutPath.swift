//
//  NSImage+CutPath.swift
//
//  Created on 08.11.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit

extension NSImage {
    /// Cuts the image using the specified bezier path.
    /// Uses CGContext for better performance compared to lockFocus/unlockFocus.
    ///
    /// This function creates a new image by applying a clipping path to the original image.
    /// The resulting image will only show the part of the original image that falls within the path.
    ///
    /// - Parameter path: The `NSBezierPath` used to clip the image.
    /// - Returns: A new `NSImage` that has been clipped by the specified path.
    func cutImage(by path: NSBezierPath) -> NSImage {
        let imageSize = size

        // Try optimized CGContext-based clipping first
        if let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil),
           let clippedCGImage = clippedCGImage(cgImage, with: path, size: imageSize)
        {
            return NSImage(cgImage: clippedCGImage, size: imageSize)
        }

        // Fallback to lockFocus for edge cases
        return cutImageWithLockFocus(by: path)
    }

    /// Clips a CGImage using a bezier path via CGContext for optimal performance.
    /// - Parameters:
    ///   - cgImage: The source CGImage to clip.
    ///   - path: The NSBezierPath defining the clipping region.
    ///   - size: The size of the output image.
    /// - Returns: A clipped CGImage, or nil if context creation fails.
    private func clippedCGImage(_ cgImage: CGImage, with path: NSBezierPath, size: CGSize) -> CGImage? {
        let width = Int(size.width)
        let height = Int(size.height)

        guard width > 0, height > 0 else { return nil }

        let colorSpace = cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return nil
        }

        // Convert NSBezierPath to CGPath and apply clipping
        let cgPath = path.cgPath
        context.addPath(cgPath)
        context.clip(using: .evenOdd)

        // Draw the image within the clipped region
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))

        return context.makeImage()
    }

    /// Fallback clipping method using lockFocus for images that can't be converted to CGImage.
    /// - Parameter path: The NSBezierPath defining the clipping region.
    /// - Returns: A new clipped NSImage.
    private func cutImageWithLockFocus(by path: NSBezierPath) -> NSImage {
        let imageSize = size
        let cutImage = NSImage(size: imageSize)

        cutImage.lockFocus()

        let clippingPath = path
        clippingPath.windingRule = .evenOdd
        clippingPath.addClip()

        draw(in: NSRect(origin: .zero, size: imageSize))

        cutImage.unlockFocus()

        return cutImage
    }
}

// MARK: - NSBezierPath CGPath Conversion

extension NSBezierPath {
    /// Converts an NSBezierPath to a CGPath.
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)

        for i in 0 ..< elementCount {
            let type = element(at: i, associatedPoints: &points)

            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            case .cubicCurveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .quadraticCurveTo:
                path.addQuadCurve(to: points[1], control: points[0])
            @unknown default:
                break
            }
        }

        return path
    }
}
