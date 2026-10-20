//
//  NSImageScaleTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("NSImage Scale Extension")
struct NSImageScaleTests {
    // MARK: - ScalingMode.aspectRatio Tests

    @Test("aspectFit returns smaller ratio")
    func aspectFit_returnsSmallerRatio() {
        let mode = NSImage.ScalingMode.aspectFit

        // Target 100x50, Source 200x200
        // aspectWidth = 100/200 = 0.5
        // aspectHeight = 50/200 = 0.25
        // aspectFit takes min = 0.25
        let ratio = mode.aspectRatio(
            between: CGSize(width: 100, height: 50),
            and: CGSize(width: 200, height: 200)
        )

        #expect(ratio == 0.25)
    }

    @Test("aspectFill returns larger ratio")
    func aspectFill_returnsLargerRatio() {
        let mode = NSImage.ScalingMode.aspectFill

        // Target 100x50, Source 200x200
        // aspectWidth = 100/200 = 0.5
        // aspectHeight = 50/200 = 0.25
        // aspectFill takes max = 0.5
        let ratio = mode.aspectRatio(
            between: CGSize(width: 100, height: 50),
            and: CGSize(width: 200, height: 200)
        )

        #expect(ratio == 0.5)
    }

    @Test("aspectRatio with equal sizes returns 1.0")
    func aspectRatio_equalSizes() {
        let fitRatio = NSImage.ScalingMode.aspectFit.aspectRatio(
            between: CGSize(width: 100, height: 100),
            and: CGSize(width: 100, height: 100)
        )

        let fillRatio = NSImage.ScalingMode.aspectFill.aspectRatio(
            between: CGSize(width: 100, height: 100),
            and: CGSize(width: 100, height: 100)
        )

        #expect(fitRatio == 1.0)
        #expect(fillRatio == 1.0)
    }

    @Test("aspectRatio with wider target")
    func aspectRatio_widerTarget() {
        // Target 200x100, Source 100x100
        // aspectWidth = 200/100 = 2.0
        // aspectHeight = 100/100 = 1.0
        let fitRatio = NSImage.ScalingMode.aspectFit.aspectRatio(
            between: CGSize(width: 200, height: 100),
            and: CGSize(width: 100, height: 100)
        )

        let fillRatio = NSImage.ScalingMode.aspectFill.aspectRatio(
            between: CGSize(width: 200, height: 100),
            and: CGSize(width: 100, height: 100)
        )

        #expect(fitRatio == 1.0) // min(2.0, 1.0)
        #expect(fillRatio == 2.0) // max(2.0, 1.0)
    }

    @Test("aspectRatio with taller target")
    func aspectRatio_tallerTarget() {
        // Target 100x200, Source 100x100
        // aspectWidth = 100/100 = 1.0
        // aspectHeight = 200/100 = 2.0
        let fitRatio = NSImage.ScalingMode.aspectFit.aspectRatio(
            between: CGSize(width: 100, height: 200),
            and: CGSize(width: 100, height: 100)
        )

        let fillRatio = NSImage.ScalingMode.aspectFill.aspectRatio(
            between: CGSize(width: 100, height: 200),
            and: CGSize(width: 100, height: 100)
        )

        #expect(fitRatio == 1.0) // min(1.0, 2.0)
        #expect(fillRatio == 2.0) // max(1.0, 2.0)
    }

    // MARK: - scaled(to:scalingMode:) Tests

    @Test("scaled returns image with target size")
    func scaled_returnsImageWithTargetSize() {
        let sourceImage = createTestImage(size: NSSize(width: 100, height: 100))
        let targetSize = CGSize(width: 50, height: 50)

        let scaledImage = sourceImage.scaled(to: targetSize)

        #expect(scaledImage.size.width == 50)
        #expect(scaledImage.size.height == 50)
    }

    @Test("scaled with aspectFit maintains aspect ratio")
    func scaled_aspectFit_maintainsAspectRatio() {
        let sourceImage = createTestImage(size: NSSize(width: 200, height: 100))
        let targetSize = CGSize(width: 50, height: 50)

        let scaledImage = sourceImage.scaled(to: targetSize, scalingMode: .aspectFit)

        // Output size should be the target size
        #expect(scaledImage.size.width == 50)
        #expect(scaledImage.size.height == 50)
    }

    @Test("scaled with aspectFill maintains aspect ratio")
    func scaled_aspectFill_maintainsAspectRatio() {
        let sourceImage = createTestImage(size: NSSize(width: 200, height: 100))
        let targetSize = CGSize(width: 50, height: 50)

        let scaledImage = sourceImage.scaled(to: targetSize, scalingMode: .aspectFill)

        // Output size should be the target size
        #expect(scaledImage.size.width == 50)
        #expect(scaledImage.size.height == 50)
    }

    @Test("scaled with different source aspect ratios")
    func scaled_differentSourceAspects() {
        let wideImage = createTestImage(size: NSSize(width: 200, height: 100))
        let tallImage = createTestImage(size: NSSize(width: 100, height: 200))
        let squareImage = createTestImage(size: NSSize(width: 100, height: 100))
        let targetSize = CGSize(width: 64, height: 64)

        let scaledWide = wideImage.scaled(to: targetSize)
        let scaledTall = tallImage.scaled(to: targetSize)
        let scaledSquare = squareImage.scaled(to: targetSize)

        #expect(scaledWide.size == targetSize)
        #expect(scaledTall.size == targetSize)
        #expect(scaledSquare.size == targetSize)
    }

    @Test("scaled to larger size")
    func scaled_toLargerSize() {
        let sourceImage = createTestImage(size: NSSize(width: 50, height: 50))
        let targetSize = CGSize(width: 200, height: 200)

        let scaledImage = sourceImage.scaled(to: targetSize)

        #expect(scaledImage.size.width == 200)
        #expect(scaledImage.size.height == 200)
    }

    @Test("scaled default scaling mode is aspectFill")
    func scaled_defaultScalingMode() {
        let sourceImage = createTestImage(size: NSSize(width: 200, height: 100))
        let targetSize = CGSize(width: 50, height: 50)

        // Call without explicit scaling mode (should use aspectFill)
        let scaledDefault = sourceImage.scaled(to: targetSize)
        let scaledExplicit = sourceImage.scaled(to: targetSize, scalingMode: .aspectFill)

        // Both should produce images of the same size
        #expect(scaledDefault.size == scaledExplicit.size)
    }

    // MARK: - Edge Cases

    @Test("scaled with very small target")
    func scaled_verySmallTarget() {
        let sourceImage = createTestImage(size: NSSize(width: 512, height: 512))
        let targetSize = CGSize(width: 1, height: 1)

        let scaledImage = sourceImage.scaled(to: targetSize)

        #expect(scaledImage.size.width == 1)
        #expect(scaledImage.size.height == 1)
    }

    @Test("scaled with same size returns new image")
    func scaled_sameSizeReturnsNewImage() {
        let sourceImage = createTestImage(size: NSSize(width: 100, height: 100))
        let targetSize = CGSize(width: 100, height: 100)

        let scaledImage = sourceImage.scaled(to: targetSize)

        #expect(scaledImage.size == sourceImage.size)
        // Should be a different image instance
        #expect(scaledImage !== sourceImage)
    }

    // MARK: - Helpers

    private func createTestImage(size: NSSize, color: NSColor = .red) -> NSImage {
        TestImageFactory.solidColor(size: size, color: color)
    }
}
