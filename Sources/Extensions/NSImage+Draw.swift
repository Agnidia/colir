//
//  NSImage+Draw.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 08.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

public extension NSImage {
    /// Draws an image onto the current image at a specified position.
    ///
    /// - Parameters:
    ///   - image: The `NSImage` to be drawn onto the current image.
    ///   - position: The position at which to draw the image. Default is `.zero`.
    /// - Returns: A new `NSImage` with the drawn image.
    func draw(image: NSImage, at position: CGPoint = .zero) -> NSImage {
        let img = NSImage(size: size)
        img.lockFocus()
        draw(in: CGRect(origin: .zero, size: size))
        image.draw(in: CGRect(origin: position, size: size))
        img.unlockFocus()
        return img
    }
    
    /// Draws an emoji character onto the current image.
    ///
    /// - Parameter emoji: The emoji character to be drawn.
    /// - Returns: A new `NSImage` with the drawn emoji.
    func draw(emoji: Character) -> NSImage {
        var fontScale: CGFloat = 2.2
        var xOffset: CGFloat = (1 * size.width / 512)
        let yOffset: CGFloat = (18 * size.height / 512)
        var yScale = 4.6
        
        if size.width == 32 {
            fontScale = 2.3
            xOffset += 1
            yScale = 3.4
        } else if size.width == 16 {
            fontScale = 2.2
            yScale = 3
        }
        
        let font = NSFont.boldSystemFont(ofSize: size.height / fontScale)
        let textStyle = NSMutableParagraphStyle.default
        let textFontAttributes: [NSAttributedString.Key : AnyObject] = [
            .font: font,
            .paragraphStyle: textStyle
        ]
        
        let img: NSImage = .init(size: size)
        img.lockFocus()
        draw(in: .init(origin: .zero, size: size))
        String(emoji).draw(
            in: .init(
                origin: .init(x: (size.width / 4) - xOffset,
                              y: -((size.height / yScale) + yOffset)),
                size: size
            ),
            withAttributes: textFontAttributes
        )
        img.unlockFocus()
        return img
    }
}
