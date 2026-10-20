//
//  NSImage+Alpha.swift
//
//  Created on 05.11.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit

extension NSImage {
    /// Adjusts the alpha value of the image's pixels.
    ///
    /// - Parameter value: The new alpha value, ranging from 0 to 255.
    /// - Returns: A new `NSImage` instance with the adjusted alpha values, or `nil` if the image could not be processed.
    public func alpha(value: UInt8) -> NSImage? {
        guard let imageRef = cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }

        /// Graphics context parameters
        let bitsPerComponent = 8
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = RGBA32.bitmapInfo
        let width = imageRef.width
        let height = imageRef.height

        // Back image

        let backImageBytesPerRow = width * 4
        let backImagePixelCount = width * height
        guard let contextBackImage = CGContext(data: nil,
                                               width: width,
                                               height: height,
                                               bitsPerComponent: bitsPerComponent,
                                               bytesPerRow: backImageBytesPerRow,
                                               space: colorspace,
                                               bitmapInfo: bitmapInfo)
        else {
            return nil
        }

        guard let dataBackImage = contextBackImage.data else {
            print("alpha: Unable to get back image buffer")
            return nil
        }

        let bufferBackImage = dataBackImage.bindMemory(to: RGBA32.self, capacity: backImagePixelCount)
        contextBackImage.draw(imageRef, in: CGRect(x: .zero, y: .zero, width: width, height: height))

        // Adjust alpha values in the image

        for offset in .zero ..< backImagePixelCount {
            let color = bufferBackImage[offset]

            bufferBackImage[offset] = RGBA32(
                red: color.redComponent,
                green: color.greenComponent,
                blue: color.blueComponent,
                alpha: UInt8(Float(color.alphaComponent) * Float(value) / 255)
            )
        }

        // Retrieve image from memory context

        guard let imgContext = CGContext(data: bufferBackImage,
                                         width: width,
                                         height: height,
                                         bitsPerComponent: bitsPerComponent,
                                         bytesPerRow: backImageBytesPerRow,
                                         space: colorspace,
                                         bitmapInfo: bitmapInfo),
            let finalCGImage = imgContext.makeImage()
        else {
            return nil
        }

        let finalImage = NSImage(cgImage: finalCGImage, size: .init(width: width, height: height))
        return finalImage
    }
}
