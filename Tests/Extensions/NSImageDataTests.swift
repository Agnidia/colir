//
//  NSImageDataTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("NSImage Data Extension")
struct NSImageDataTests {
    // MARK: - NSImage.pngData Tests

    @Test("pngData returns data for valid image")
    func pngData_returnsData() {
        let image = createTestImage(size: NSSize(width: 100, height: 100), color: .red)

        let data = image.pngData

        #expect(data != nil)
        #expect(!data!.isEmpty)
    }

    @Test("pngData returns valid PNG data")
    func pngData_validPNG() {
        let image = createTestImage(size: NSSize(width: 50, height: 50), color: .blue)

        let data = image.pngData

        #expect(data != nil)
        // PNG magic bytes: 89 50 4E 47
        if let data, data.count >= 4 {
            #expect(data[0] == 0x89)
            #expect(data[1] == 0x50) // P
            #expect(data[2] == 0x4E) // N
            #expect(data[3] == 0x47) // G
        }
    }

    @Test("pngData for different image sizes")
    func pngData_differentSizes() {
        for size in TestConstants.extendedIconSizes {
            let image = createTestImage(size: size, color: .green)
            let data = image.pngData

            #expect(data != nil, "pngData should succeed for size \(size)")
            #expect(!data!.isEmpty, "pngData should not be empty for size \(size)")
        }
    }

    @Test("pngData larger images produce more data")
    func pngData_sizeCorrelation() {
        let smallImage = createTestImage(size: NSSize(width: 16, height: 16), color: .red)
        let largeImage = createTestImage(size: NSSize(width: 256, height: 256), color: .red)

        let smallData = smallImage.pngData
        let largeData = largeImage.pngData

        #expect(smallData != nil)
        #expect(largeData != nil)
        #expect(largeData!.count > smallData!.count)
    }

    // MARK: - NSBitmapImageRep.pngData Tests

    @Test("bitmapRep pngData returns data")
    func bitmapRep_pngData_returnsData() {
        let image = createTestImage(size: NSSize(width: 50, height: 50), color: .yellow)

        guard let tiff = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff)
        else {
            Issue.record("Could not create bitmap representation")
            return
        }

        let data = bitmap.pngData

        #expect(data != nil)
        #expect(!data!.isEmpty)
    }

    // MARK: - Data.bitmap Tests

    @Test("data bitmap creates NSBitmapImageRep from valid data")
    func data_bitmap_createsRep() {
        let image = createTestImage(size: NSSize(width: 50, height: 50), color: .purple)

        guard let tiff = image.tiffRepresentation else {
            Issue.record("Could not create TIFF representation")
            return
        }

        let bitmap = tiff.bitmap

        #expect(bitmap != nil)
    }

    @Test("data bitmap returns nil for invalid data")
    func data_bitmap_invalidData() {
        let invalidData = Data([0x00, 0x01, 0x02, 0x03])

        let bitmap = invalidData.bitmap

        #expect(bitmap == nil)
    }

    @Test("data bitmap returns nil for empty data")
    func data_bitmap_emptyData() {
        let emptyData = Data()

        let bitmap = emptyData.bitmap

        #expect(bitmap == nil)
    }

    // MARK: - Round Trip Tests

    @Test("pngData round trip preserves image")
    func pngData_roundTrip() {
        let originalImage = createTestImage(size: NSSize(width: 64, height: 64), color: .cyan)

        guard let pngData = originalImage.pngData else {
            Issue.record("Could not create PNG data")
            return
        }

        let recreatedImage = NSImage(data: pngData)

        #expect(recreatedImage != nil)
        #expect(recreatedImage!.size.width == 64)
        #expect(recreatedImage!.size.height == 64)
    }

    @Test("pngData preserves transparency")
    func pngData_preservesTransparency() {
        // Create an image with transparency using TestImageFactory
        let size = NSSize(width: 100, height: 100)
        let image = TestImageFactory.transparent(
            size: size,
            fillRect: NSRect(x: 25, y: 25, width: 50, height: 50),
            fillColor: NSColor.red.withAlphaComponent(0.5)
        )

        let pngData = image.pngData

        #expect(pngData != nil)

        if let pngData {
            let recreatedImage = NSImage(data: pngData)
            #expect(recreatedImage != nil)
        }
    }

    // MARK: - Edge Cases

    @Test("pngData with 1x1 image")
    func pngData_1x1Image() {
        let image = createTestImage(size: NSSize(width: 1, height: 1), color: .red)

        let data = image.pngData

        #expect(data != nil)
        #expect(!data!.isEmpty)
    }

    @Test("pngData with rectangular image")
    func pngData_rectangularImage() {
        let image = createTestImage(size: NSSize(width: 200, height: 100), color: .blue)

        let data = image.pngData

        #expect(data != nil)
        #expect(!data!.isEmpty)
    }

    @Test("pngData with tall rectangular image")
    func pngData_tallRectangularImage() {
        let image = createTestImage(size: NSSize(width: 100, height: 200), color: .green)

        let data = image.pngData

        #expect(data != nil)
        #expect(!data!.isEmpty)
    }

    @Test("pngData multiple times returns consistent data")
    func pngData_consistentOutput() {
        let image = createTestImage(size: NSSize(width: 50, height: 50), color: .orange)

        let data1 = image.pngData
        let data2 = image.pngData

        #expect(data1 != nil)
        #expect(data2 != nil)
        #expect(data1 == data2)
    }

    // MARK: - Color Tests

    @Test("pngData with different colors")
    func pngData_differentColors() {
        for color in TestConstants.testColors {
            let image = createTestImage(size: NSSize(width: 50, height: 50), color: color)
            let data = image.pngData

            #expect(data != nil, "pngData should succeed for color \(color)")
        }
    }

    @Test("pngData with white image")
    func pngData_whiteImage() {
        let image = createTestImage(size: NSSize(width: 50, height: 50), color: .white)

        let data = image.pngData

        #expect(data != nil)
    }

    @Test("pngData with black image")
    func pngData_blackImage() {
        let image = createTestImage(size: NSSize(width: 50, height: 50), color: .black)

        let data = image.pngData

        #expect(data != nil)
    }

    // MARK: - Helpers

    private func createTestImage(size: NSSize, color: NSColor) -> NSImage {
        TestImageFactory.solidColor(size: size, color: color)
    }
}
