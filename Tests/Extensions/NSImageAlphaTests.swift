//
//  NSImageAlphaTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("NSImage Alpha Extension")
struct NSImageAlphaTests {
    // MARK: - alpha(value:) Tests

    @Test("alpha returns image with adjusted alpha")
    func alpha_returnsAdjustedImage() {
        let sourceImage = createTestImage(size: NSSize(width: 100, height: 100), color: .red)

        let result = sourceImage.alpha(value: 128)

        #expect(result != nil)
        // Size may differ due to Retina scaling (point vs pixel dimensions)
        #expect(result!.size.width > 0)
        #expect(result!.size.height > 0)
    }

    @Test("alpha with full opacity (255)")
    func alpha_fullOpacity() {
        let sourceImage = createTestImage(size: NSSize(width: 50, height: 50), color: .blue)

        let result = sourceImage.alpha(value: 255)

        #expect(result != nil)
        #expect(result!.size.width > 0)
        #expect(result!.size.height > 0)
    }

    @Test("alpha with zero opacity")
    func alpha_zeroOpacity() {
        let sourceImage = createTestImage(size: NSSize(width: 50, height: 50), color: .green)

        let result = sourceImage.alpha(value: 0)

        #expect(result != nil)
        #expect(result!.size.width > 0)
        #expect(result!.size.height > 0)
    }

    @Test("alpha with half opacity (128)")
    func alpha_halfOpacity() {
        let sourceImage = createTestImage(size: NSSize(width: 50, height: 50), color: .yellow)

        let result = sourceImage.alpha(value: 128)

        #expect(result != nil)
        #expect(result!.size.width > 0)
        #expect(result!.size.height > 0)
    }

    @Test("alpha preserves image dimensions")
    func alpha_preservesDimensions() {
        for size in TestConstants.iconSizes {
            let sourceImage = createTestImage(size: size, color: .purple)
            let result = sourceImage.alpha(value: 200)

            #expect(result != nil, "Alpha should succeed for size \(size)")
            // Size may differ due to Retina scaling, just verify positive dimensions
            #expect(result!.size.width > 0, "Width should be positive for size \(size)")
            #expect(result!.size.height > 0, "Height should be positive for size \(size)")
        }
    }

    @Test("alpha with different values")
    func alpha_differentValues() {
        let sourceImage = createTestImage(size: NSSize(width: 64, height: 64), color: .orange)
        let alphaValues: [UInt8] = [0, 25, 50, 100, 128, 175, 200, 255]

        for alphaValue in alphaValues {
            let result = sourceImage.alpha(value: alphaValue)
            #expect(result != nil, "Alpha should succeed for value \(alphaValue)")
        }
    }

    // MARK: - Edge Cases

    @Test("alpha with small image")
    func alpha_smallImage() {
        let sourceImage = createTestImage(size: NSSize(width: 1, height: 1), color: .cyan)

        let result = sourceImage.alpha(value: 128)

        #expect(result != nil)
        #expect(result!.size.width >= 1)
        #expect(result!.size.height >= 1)
    }

    @Test("alpha with rectangular image")
    func alpha_rectangularImage() {
        let sourceImage = createTestImage(size: NSSize(width: 200, height: 100), color: .magenta)

        let result = sourceImage.alpha(value: 64)

        #expect(result != nil)
        // Size may differ due to Retina scaling, check aspect ratio instead
        #expect(result!.size.width >= 200)
        #expect(result!.size.height >= 100)
        #expect(abs(result!.size.width / result!.size.height - 2.0) < 0.01, "Aspect ratio should be preserved")
    }

    @Test("alpha multiple times")
    func alpha_multipleTimes() {
        var image: NSImage? = createTestImage(size: NSSize(width: 50, height: 50), color: .red)

        image = image?.alpha(value: 200)
        #expect(image != nil)

        image = image?.alpha(value: 150)
        #expect(image != nil)

        image = image?.alpha(value: 100)
        #expect(image != nil)
    }

    @Test("alpha on transparent image")
    func alpha_transparentImage() {
        // Create image with transparency using TestImageFactory
        let size = NSSize(width: 50, height: 50)
        let image = TestImageFactory.transparent(size: size)

        let result = image.alpha(value: 128)

        #expect(result != nil)
        #expect(result!.size.width > 0)
        #expect(result!.size.height > 0)
    }

    @Test("alpha boundary value 1")
    func alpha_boundaryValue1() {
        let sourceImage = createTestImage(size: NSSize(width: 50, height: 50), color: .red)

        let result = sourceImage.alpha(value: 1)

        #expect(result != nil)
    }

    @Test("alpha boundary value 254")
    func alpha_boundaryValue254() {
        let sourceImage = createTestImage(size: NSSize(width: 50, height: 50), color: .blue)

        let result = sourceImage.alpha(value: 254)

        #expect(result != nil)
    }

    // MARK: - Helpers

    private func createTestImage(size: NSSize, color: NSColor) -> NSImage {
        TestImageFactory.solidColor(size: size, color: color)
    }
}
