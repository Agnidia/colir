//
//  RGBA32Tests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("RGBA32 Color Model")
struct RGBA32Tests {
    // MARK: - Component Extraction Tests

    @Test("Red component extracts correctly from bit-packed color")
    func redComponent_extractsCorrectValue() {
        let color = RGBA32(red: 255, green: 0, blue: 0, alpha: 255)
        #expect(color.redComponent == 255)

        let color2 = RGBA32(red: 128, green: 64, blue: 32, alpha: 16)
        #expect(color2.redComponent == 128)
    }

    @Test("Green component extracts correctly from bit-packed color")
    func greenComponent_extractsCorrectValue() {
        let color = RGBA32(red: 0, green: 255, blue: 0, alpha: 255)
        #expect(color.greenComponent == 255)

        let color2 = RGBA32(red: 128, green: 64, blue: 32, alpha: 16)
        #expect(color2.greenComponent == 64)
    }

    @Test("Blue component extracts correctly from bit-packed color")
    func blueComponent_extractsCorrectValue() {
        let color = RGBA32(red: 0, green: 0, blue: 255, alpha: 255)
        #expect(color.blueComponent == 255)

        let color2 = RGBA32(red: 128, green: 64, blue: 32, alpha: 16)
        #expect(color2.blueComponent == 32)
    }

    @Test("Alpha component extracts correctly from bit-packed color")
    func alphaComponent_extractsCorrectValue() {
        let color = RGBA32(red: 0, green: 0, blue: 0, alpha: 255)
        #expect(color.alphaComponent == 255)

        let color2 = RGBA32(red: 128, green: 64, blue: 32, alpha: 16)
        #expect(color2.alphaComponent == 16)

        let color3 = RGBA32(red: 0, green: 0, blue: 0, alpha: 0)
        #expect(color3.alphaComponent == 0)
    }

    // MARK: - Initialization Tests

    @Test("Init from NSColor converts correctly")
    func initFromColor_convertsCorrectly() {
        // Pure red
        let redNSColor = NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let redRGBA = RGBA32(color: redNSColor)
        #expect(redRGBA.redComponent == 255)
        #expect(redRGBA.greenComponent == 0)
        #expect(redRGBA.blueComponent == 0)
        #expect(redRGBA.alphaComponent == 255)

        // Pure green
        let greenNSColor = NSColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        let greenRGBA = RGBA32(color: greenNSColor)
        #expect(greenRGBA.redComponent == 0)
        #expect(greenRGBA.greenComponent == 255)
        #expect(greenRGBA.blueComponent == 0)

        // Half values
        let halfColor = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let halfRGBA = RGBA32(color: halfColor)
        // Allow for rounding differences (127 or 128)
        #expect(halfRGBA.redComponent >= 127 && halfRGBA.redComponent <= 128)
        #expect(halfRGBA.greenComponent >= 127 && halfRGBA.greenComponent <= 128)
        #expect(halfRGBA.blueComponent >= 127 && halfRGBA.blueComponent <= 128)
        #expect(halfRGBA.alphaComponent >= 127 && halfRGBA.alphaComponent <= 128)
    }

    @Test("Init from components packs correctly")
    func initFromComponents_packsCorrectly() {
        let color = RGBA32(red: 100, green: 150, blue: 200, alpha: 250)

        #expect(color.redComponent == 100)
        #expect(color.greenComponent == 150)
        #expect(color.blueComponent == 200)
        #expect(color.alphaComponent == 250)
    }

    @Test("Component roundtrip preserves values")
    func componentRoundtrip_preservesValues() {
        for r in stride(from: UInt8(0), to: 255, by: 50) {
            for g in stride(from: UInt8(0), to: 255, by: 50) {
                for b in stride(from: UInt8(0), to: 255, by: 50) {
                    let color = RGBA32(red: r, green: g, blue: b, alpha: 255)
                    #expect(color.redComponent == r)
                    #expect(color.greenComponent == g)
                    #expect(color.blueComponent == b)
                }
            }
        }
    }

    // MARK: - Color Tolerance Tests

    @Test("Colors tolerance calculates min and max correctly")
    func colorsTolerance_calculatesMinMax() {
        let color = RGBA32(red: 100, green: 100, blue: 100, alpha: 255)
        let (min, max) = color.colors(tolerance: 10)

        #expect(min.redComponent == 90)
        #expect(min.greenComponent == 90)
        #expect(min.blueComponent == 90)
        #expect(min.alphaComponent == 245)

        #expect(max.redComponent == 110)
        #expect(max.greenComponent == 110)
        #expect(max.blueComponent == 110)
        #expect(max.alphaComponent == 255)
    }

    @Test("Colors tolerance clamps at boundaries")
    func colorsTolerance_clampsAtBoundaries() {
        // Test lower boundary clamping
        let lowColor = RGBA32(red: 5, green: 5, blue: 5, alpha: 5)
        let (lowMin, _) = lowColor.colors(tolerance: 10)
        #expect(lowMin.redComponent == 0)
        #expect(lowMin.greenComponent == 0)
        #expect(lowMin.blueComponent == 0)
        #expect(lowMin.alphaComponent == 0)

        // Test upper boundary clamping
        let highColor = RGBA32(red: 250, green: 250, blue: 250, alpha: 250)
        let (_, highMax) = highColor.colors(tolerance: 10)
        #expect(highMax.redComponent == 255)
        #expect(highMax.greenComponent == 255)
        #expect(highMax.blueComponent == 255)
        #expect(highMax.alphaComponent == 255)
    }

    // MARK: - Between Range Tests

    @Test("Between returns true when color is in range")
    func between_returnsTrueInRange() {
        let testColor = RGBA32(red: 100, green: 100, blue: 100, alpha: 255)
        let minColor = RGBA32(red: 90, green: 90, blue: 90, alpha: 245)
        let maxColor = RGBA32(red: 110, green: 110, blue: 110, alpha: 255)

        #expect(testColor.between(minColor, maxColor))
    }

    @Test("Between returns false when color is out of range")
    func between_returnsFalseOutOfRange() {
        let testColor = RGBA32(red: 200, green: 100, blue: 100, alpha: 255)
        let minColor = RGBA32(red: 90, green: 90, blue: 90, alpha: 245)
        let maxColor = RGBA32(red: 110, green: 110, blue: 110, alpha: 255)

        #expect(!testColor.between(minColor, maxColor))
    }

    @Test("Between boundary cases")
    func between_boundaryValues() {
        let minColor = RGBA32(red: 100, green: 100, blue: 100, alpha: 255)
        let maxColor = RGBA32(red: 100, green: 100, blue: 100, alpha: 255)

        // Exact match should be in range
        let exactMatch = RGBA32(red: 100, green: 100, blue: 100, alpha: 255)
        #expect(exactMatch.between(minColor, maxColor))
    }

    // MARK: - Color Difference Tests

    @Test("Color difference calculates Euclidean distance")
    func colorDiff_calculatesEuclideanDistance() {
        let color1 = RGBA32(red: 0, green: 0, blue: 0, alpha: 255)
        let color2 = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)

        let diff = color1.colorDiff(otherColor: color2)
        // sqrt(255^2 + 255^2 + 255^2) = sqrt(195075) = 441.67 -> clamped to 255
        #expect(diff == 255)
    }

    @Test("Color difference returns 0 for identical colors")
    func colorDiff_returnsZeroForIdentical() {
        let color = RGBA32(red: 128, green: 64, blue: 192, alpha: 255)
        let diff = color.colorDiff(otherColor: color)
        #expect(diff == 0)
    }

    @Test("Color difference for small differences")
    func colorDiff_smallDifferences() {
        let color1 = RGBA32(red: 100, green: 100, blue: 100, alpha: 255)
        let color2 = RGBA32(red: 101, green: 100, blue: 100, alpha: 255)

        let diff = color1.colorDiff(otherColor: color2)
        // sqrt(1^2 + 0 + 0) = 1
        #expect(diff == 1)
    }

    // MARK: - Equatable Tests

    @Test("Equatable returns true for equal colors")
    func equatable_equalColors() {
        let color1 = RGBA32(red: 100, green: 150, blue: 200, alpha: 250)
        let color2 = RGBA32(red: 100, green: 150, blue: 200, alpha: 250)

        #expect(color1 == color2)
    }

    @Test("Equatable returns false for different colors")
    func equatable_differentColors() {
        let color1 = RGBA32(red: 100, green: 150, blue: 200, alpha: 250)
        let color2 = RGBA32(red: 101, green: 150, blue: 200, alpha: 250)

        #expect(color1 != color2)
    }

    // MARK: - Hashable Tests

    @Test("Hashable produces consistent hashes")
    func hashable_consistentHashes() {
        let color1 = RGBA32(red: 100, green: 150, blue: 200, alpha: 250)
        let color2 = RGBA32(red: 100, green: 150, blue: 200, alpha: 250)

        #expect(color1.hashValue == color2.hashValue)
    }
}
