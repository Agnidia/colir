//
//  NSImage+Tint.swift
//
//  Created on 05.11.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit

extension NSImage {
    /// Creates a list of tinted icons from the current image.
    ///
    /// - Parameter color: The color to tint the icons.
    /// - Returns: An array of tinted `NSImage` objects.
    public func tintedIcns(_ color: NSColor) -> [NSImage] {
        var icons = [NSImage]()
        for icon in representations {
            let iconSize = icon.size
            guard let cgImage = icon.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                continue
            }
            let newImage = NSImage(cgImage: cgImage, size: iconSize)
            guard let tintedImage = newImage.tint(color: NSColor(hex: "#7dcdfa"), withColor: color) else {
                continue
            }
            icons.append(tintedImage)
        }
        return icons
    }

    /// Tints the image by replacing a specific color with a target color.
    ///
    /// - Parameters:
    ///   - color: The source color to be replaced.
    ///   - withColor: The target color to replace the source color.
    ///   - tolerance: The tolerance level for color replacement, ranging from 0 to 1. Default is 0.6.
    /// - Returns: A new `NSImage` with the specified color replaced, or `nil` if the operation fails.
    public func tint(color: NSColor, withColor: NSColor, tolerance: CGFloat = 0.6) -> NSImage? {
        guard let imageRef = cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }

        let logger = Log(category: .imageProcessing)
        let startAt = CFAbsoluteTimeGetCurrent()

        let searchColorRGB = RGBA32(color: color)
        let (searchColorMin, searchColorMax) = searchColorRGB.colors(tolerance: UInt8(255 * tolerance))
        let replacementColorRGB = RGBA32(color: withColor)

        // Graphics context parameters
        let bitsPerComponent = 8
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = RGBA32.bitmapInfo
        let width = imageRef.width
        let height = imageRef.height

        // Create context for back image
        let backImageBytesPerRow = width * 4
        let backImagePixelCount = width * height
        guard let contextBackImage = CGContext(data: nil,
                                               width: width,
                                               height: height,
                                               bitsPerComponent: bitsPerComponent,
                                               bytesPerRow: backImageBytesPerRow,
                                               space: colorspace,
                                               bitmapInfo: bitmapInfo),
            let dataBackImage = contextBackImage.data
        else {
            logger.debug("Unable to get back image buffer")
            return nil
        }

        let bufferBackImage = dataBackImage.bindMemory(to: RGBA32.self, capacity: width * height)
        contextBackImage.draw(imageRef, in: CGRect(x: .zero, y: .zero, width: width, height: height))

        // Prepare to iterate over image pixels
        var updatedColors: [RGBA32: RGBA32] = .init(minimumCapacity: backImagePixelCount)

        for offset in 0 ..< backImagePixelCount {
            let color = bufferBackImage[offset]

            guard let updatedColor = updatedColors[color] else {
                if color.between(searchColorMin, searchColorMax) {
                    let offsetC = color.colorDiff(otherColor: searchColorRGB)
                    let newColor = replacementColorRGB.colors(tolerance: offsetC).0
                    bufferBackImage[offset] = newColor
                    updatedColors[color] = newColor
                }
                continue
            }
            bufferBackImage[offset] = updatedColor
        }

        // Retrieve image from memory context
        guard let img = CGContext(data: bufferBackImage,
                                  width: width,
                                  height: height,
                                  bitsPerComponent: bitsPerComponent,
                                  bytesPerRow: backImageBytesPerRow,
                                  space: colorspace,
                                  bitmapInfo: bitmapInfo),
            let cgImage = img.makeImage()
        else {
            logger.debug("Unable to create image from buffer")
            return nil
        }

        let finalImage = NSImage(cgImage: cgImage, size: .init(width: width, height: height))
        logger.elapsedTime(startAt: startAt)

        return finalImage
    }
}
