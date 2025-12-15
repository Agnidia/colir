//
//  NSColor+Hex.swift
//
//  Created on 24.02.2024.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit

extension NSColor {
    /// Returns the hexadecimal string representation of the color.
    ///
    /// - Returns: A string representing the color in hexadecimal format, e.g., `#RRGGBB`. If the color cannot be converted, returns `#FFFFFF`.
    var hexString: String {
        // Attempt to convert the color to a component-based color space
        guard let rgbColor = usingType(.componentBased)?.usingColorSpace(.deviceRGB) else {
            return "FFFFFF"
        }

        // Extract red, green, and blue components
        let red = Int(round(rgbColor.redComponent * 0xFF))
        let green = Int(round(rgbColor.greenComponent * 0xFF))
        let blue = Int(round(rgbColor.blueComponent * 0xFF))

        // Format the color components into a hex string
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)

        return hexString as String
    }
}
