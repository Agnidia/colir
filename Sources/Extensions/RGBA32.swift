//
//  RGBA32.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 05.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

/// Red Green Blue Alpha color
///
public struct RGBA32: Equatable, Hashable {
    private var color: UInt32

    /// The red component of the color.
    var redComponent: UInt8 {
        return UInt8((color >> 24) & 255)
    }

    /// The green component of the color.
    var greenComponent: UInt8 {
        return UInt8((color >> 16) & 255)
    }

    /// The blue component of the color.
    var blueComponent: UInt8 {
        return UInt8((color >> 8) & 255)
    }

    /// The alpha component of the color.
    var alphaComponent: UInt8 {
        return UInt8((color >> 0) & 255)
    }

    /// Initializes an `RGBA32` instance with a given `NSColor`.
    ///
    /// - Parameter color: The `NSColor` to initialize the `RGBA32` instance with.
    init(color: NSColor) {
        var red: CGFloat = .zero
        var green: CGFloat = .zero
        var blue: CGFloat = .zero
        var alpha: CGFloat = .zero

        color.usingColorSpace(.deviceRGB)?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        self.color = (UInt32(red * 255) << 24) | (UInt32(green * 255) << 16) | (UInt32(blue * 255) << 8) | (UInt32(alpha * 255) << 0)
    }

    /// Initializes an `RGBA32` instance with given red, green, blue, and alpha components.
    ///
    /// - Parameters:
    ///   - red: The red component.
    ///   - green: The green component.
    ///   - blue: The blue component.
    ///   - alpha: The alpha component.
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let red = UInt32(red)
        let green = UInt32(green)
        let blue = UInt32(blue)
        let alpha = UInt32(alpha)
        color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
    }

    /// Returns the minimum and maximum colors with a given tolerance.
    ///
    /// - Parameter tolerance: The tolerance value.
    /// - Returns: A tuple containing the minimum and maximum `RGBA32` colors.
    func colors(tolerance: UInt8) -> (RGBA32, RGBA32) {
        let red = redComponent
        let green = greenComponent
        let blue = blueComponent
        let alpha = alphaComponent

        let redMin = red < tolerance ? .zero : red - tolerance
        let greenMin = green < tolerance ? .zero : green - tolerance
        let blueMin = blue < tolerance ? .zero : blue - tolerance
        let alphaMin = alpha < tolerance ? .zero : alpha - tolerance

        let redMax = red > (255 - tolerance) ? 255 : red + tolerance
        let greenMax = green > (255 - tolerance) ? 255 : green + tolerance
        let blueMax = blue > (255 - tolerance) ? 255 : blue + tolerance
        let alphaMax = alpha > (255 - tolerance) ? 255 : alpha + tolerance

        return (RGBA32(red: redMin, green: greenMin, blue: blueMin, alpha: alphaMin),
                RGBA32(red: redMax, green: greenMax, blue: blueMax, alpha: alphaMax))
    }

    /// Determines if the color is within the range of the given minimum and maximum colors.
    ///
    /// - Parameters:
    ///   - min: The minimum `RGBA32` color.
    ///   - max: The maximum `RGBA32` color.
    /// - Returns: A boolean indicating whether the color is within the specified range.
    func between(_ min: RGBA32, _ max: RGBA32) -> Bool {
        redComponent >= min.redComponent && redComponent <= max.redComponent &&
            greenComponent >= min.greenComponent && greenComponent <= max.greenComponent &&
            blueComponent >= min.blueComponent && blueComponent <= max.blueComponent
    }

    /// Computes the color difference between the current color and another `RGBA32` color.
    ///
    /// - Parameter otherColor: The other `RGBA32` color to compare with.
    /// - Returns: The color difference as a `UInt8` value.
    func colorDiff(otherColor: RGBA32) -> UInt8 {
        let r = pow(Double(redComponent) - Double(otherColor.redComponent), 2)
        let g = pow(Double(greenComponent) - Double(otherColor.greenComponent), 2)
        let b = pow(Double(blueComponent) - Double(otherColor.blueComponent), 2)
        let result = min(sqrt(r + g + b), 255)

        return UInt8(result)
    }

    /// The bitmap info for `RGBA32`.
    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
}
