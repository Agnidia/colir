//
//  NSImage+Scale.swift
//
//  Created on 08.11.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit

extension NSImage {
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit

        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth = size.width / otherSize.width
            let aspectHeight = size.height / otherSize.height

            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }

    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    /// Uses CGContext for better performance compared to lockFocus/unlockFocus.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: ScalingMode = .aspectFill) -> NSImage {
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)

        // Build the rectangle representing the area to be drawn
        var scaledImageRect = CGRect.zero
        scaledImageRect.size.width = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y = (newSize.height - size.height * aspectRatio) / 2.0

        // Try optimized CGContext-based scaling first
        if let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil),
           let scaledCGImage = scaledCGImage(cgImage, to: newSize, drawingIn: scaledImageRect)
        {
            return NSImage(cgImage: scaledCGImage, size: newSize)
        }

        // Fallback to lockFocus for edge cases (e.g., vector images)
        return scaledWithLockFocus(to: newSize, in: scaledImageRect)
    }

    /// Scales a CGImage using CGContext for optimal performance.
    /// - Parameters:
    ///   - cgImage: The source CGImage to scale.
    ///   - newSize: The target size for the output image.
    ///   - drawingRect: The rectangle within the target size where the image should be drawn.
    /// - Returns: A scaled CGImage, or nil if context creation fails.
    private func scaledCGImage(_ cgImage: CGImage, to newSize: CGSize, drawingIn drawingRect: CGRect) -> CGImage? {
        let width = Int(newSize.width)
        let height = Int(newSize.height)

        guard width > 0, height > 0 else { return nil }

        let colorSpace = cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = cgImage.alphaInfo == .none
            ? CGImageAlphaInfo.noneSkipLast.rawValue
            : CGImageAlphaInfo.premultipliedLast.rawValue

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

        context.interpolationQuality = .high
        context.draw(cgImage, in: drawingRect)

        return context.makeImage()
    }

    /// Fallback scaling method using lockFocus for images that can't be converted to CGImage.
    /// - Parameters:
    ///   - newSize: The target size for the output image.
    ///   - drawingRect: The rectangle within the target size where the image should be drawn.
    /// - Returns: A new scaled NSImage.
    private func scaledWithLockFocus(to newSize: CGSize, in drawingRect: CGRect) -> NSImage {
        let scaledImage = NSImage(size: newSize)
        scaledImage.lockFocus()
        draw(in: drawingRect)
        scaledImage.unlockFocus()
        return scaledImage
    }
}
