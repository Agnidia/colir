//
//  String+Emoji.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import Foundation

extension Character {
    /// Checks if the character is a simple emoji.
    /// A simple emoji is a single scalar that is an emoji.
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else {
            return false
        }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    /// Checks if the character is combined into an emoji.
    /// An emoji is considered combined if it has multiple scalars and the first scalar is an emoji.
    var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    }

    /// Checks if the character is an emoji.
    /// A character is an emoji if it is either a simple emoji or a combined emoji.
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    /// Checks if the string contains any emoji.
    var containsEmoji: Bool {
        contains(where: \.isEmoji)
    }
}

extension Character {
    private static let refUnicodeSize: CGFloat = 8
    private static let refUnicodePng = Character("\u{1fff}").png(ofSize: Character.refUnicodeSize)

    /// Generates a PNG representation of the character with the specified font size.
    ///
    /// - Parameter fontSize: The size of the font to use for the character.
    /// - Returns: The PNG data of the character rendered with the specified font size, or nil if the PNG data could not be generated.
    func png(ofSize fontSize: CGFloat) -> Data? {
        let attributes = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: fontSize)]
        let charStr = "\(self)" as NSString
        let size = charStr.size(withAttributes: attributes)

        let img = NSImage(size: size, flipped: false) { _ in
            charStr.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
            return true
        }

        return img.tiffRepresentation
    }

    /// Checks if the character's Unicode representation is available.
    ///
    /// - Returns: A Boolean value indicating whether the Unicode representation of the character is available.
    func unicodeAvailable() -> Bool {
        if let refUnicodePng = Character.refUnicodePng, let myPng = png(ofSize: Character.refUnicodeSize) {
            return refUnicodePng != myPng
        }

        return false
    }
}
