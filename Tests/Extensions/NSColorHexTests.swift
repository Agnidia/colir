//
//  NSColorHexTests.swift
//  colirTests
//
//  Created by Claude Code on 2025-12-15.
//  Copyright (c) 2025 IGR Software. All rights reserved.
//

import AppKit
@testable import colir
import Testing

@Suite("NSColor Hex Extension")
struct NSColorHexTests {
    // MARK: - Basic Color Conversion Tests

    @Test("Red color converts to correct hex string")
    func hexString_redColor() {
        let red = NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        #expect(red.hexString == "#FF0000")
    }

    @Test("Green color converts to correct hex string")
    func hexString_greenColor() {
        let green = NSColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        #expect(green.hexString == "#00FF00")
    }

    @Test("Blue color converts to correct hex string")
    func hexString_blueColor() {
        let blue = NSColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        #expect(blue.hexString == "#0000FF")
    }

    @Test("White color converts to correct hex string")
    func hexString_whiteColor() {
        let white = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        #expect(white.hexString == "#FFFFFF")
    }

    @Test("Black color converts to correct hex string")
    func hexString_blackColor() {
        let black = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        #expect(black.hexString == "#000000")
    }

    // MARK: - Intermediate Value Tests

    @Test("Gray color converts correctly")
    func hexString_grayColor() {
        let gray = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        // 0.5 * 255 = 127.5, rounds to 128 (0x80) or 127 (0x7F)
        let hex = gray.hexString
        #expect(hex == "#808080" || hex == "#7F7F7F")
    }

    @Test("Custom color converts correctly")
    func hexString_customColor() {
        // RGB(100, 150, 200) = 0x6496C8
        let custom = NSColor(red: 100.0 / 255.0, green: 150.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
        let hex = custom.hexString
        #expect(hex == "#6496C8")
    }

    // MARK: - Format Tests

    @Test("Hex string starts with hash")
    func hexString_startsWithHash() {
        let color = NSColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0)
        #expect(color.hexString.hasPrefix("#"))
    }

    @Test("Hex string has correct length")
    func hexString_correctLength() {
        let color = NSColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0)
        #expect(color.hexString.count == 7) // "#RRGGBB"
    }

    @Test("Hex string uses uppercase letters")
    func hexString_uppercaseLetters() {
        let color = NSColor(red: 0.67, green: 0.78, blue: 0.89, alpha: 1.0)
        let hex = color.hexString

        // Check that any letters are uppercase
        let letters = hex.filter { $0.isLetter }
        for letter in letters {
            #expect(letter.isUppercase)
        }
    }

    // MARK: - Alpha Channel Tests

    @Test("Alpha channel is ignored in hex output")
    func hexString_ignoresAlpha() {
        let opaqueRed = NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let transparentRed = NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        let fullyTransparentRed = NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)

        #expect(opaqueRed.hexString == "#FF0000")
        #expect(transparentRed.hexString == "#FF0000")
        #expect(fullyTransparentRed.hexString == "#FF0000")
    }

    // MARK: - Color Space Tests

    @Test("Device RGB color space converts correctly")
    func hexString_deviceRGBColorSpace() {
        var components: [CGFloat] = [1.0, 0.0, 0.0, 1.0]
        let color = NSColor(colorSpace: .deviceRGB,
                            components: &components,
                            count: 4)
        #expect(color.hexString == "#FF0000")
    }

    @Test("sRGB color space converts correctly")
    func hexString_sRGBColorSpace() {
        var components: [CGFloat] = [0.0, 1.0, 0.0, 1.0]
        let color = NSColor(colorSpace: .sRGB,
                            components: &components,
                            count: 4)
        #expect(color.hexString == "#00FF00")
    }

    // MARK: - System Colors Tests

    @Test("System red color converts")
    func hexString_systemRed() {
        let hex = NSColor.systemRed.hexString
        #expect(hex.hasPrefix("#"))
        #expect(hex.count == 7)
    }

    @Test("System blue color converts")
    func hexString_systemBlue() {
        let hex = NSColor.systemBlue.hexString
        #expect(hex.hasPrefix("#"))
        #expect(hex.count == 7)
    }

    // MARK: - Edge Cases

    @Test("Very small color values")
    func hexString_verySmallValues() {
        let color = NSColor(red: 1.0 / 255.0, green: 2.0 / 255.0, blue: 3.0 / 255.0, alpha: 1.0)
        #expect(color.hexString == "#010203")
    }

    @Test("Near-max color values")
    func hexString_nearMaxValues() {
        let color = NSColor(red: 254.0 / 255.0, green: 253.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
        #expect(color.hexString == "#FEFDFC")
    }

    // MARK: - Named Colors

    @Test("Named colors convert")
    func hexString_namedColors() {
        // NSColor.red, .green, etc. are calibrated colors
        let redHex = NSColor.red.hexString
        let greenHex = NSColor.green.hexString
        let blueHex = NSColor.blue.hexString

        #expect(redHex.hasPrefix("#"))
        #expect(greenHex.hasPrefix("#"))
        #expect(blueHex.hasPrefix("#"))
    }

    // MARK: - Consistency Tests

    @Test("Same color produces same hex string")
    func hexString_consistency() {
        let color = NSColor(red: 0.333, green: 0.666, blue: 0.999, alpha: 1.0)

        let hex1 = color.hexString
        let hex2 = color.hexString
        let hex3 = color.hexString

        #expect(hex1 == hex2)
        #expect(hex2 == hex3)
    }
}
