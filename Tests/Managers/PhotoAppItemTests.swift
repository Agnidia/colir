//
//  PhotoAppItemTests.swift
//  colirTests
//
//  Created by Claude Code on 2025-12-15.
//  Copyright (c) 2025 IGR Software. All rights reserved.
//

import AppKit
@testable import colir
import Testing

@Suite("PhotoAppItem Tests")
struct PhotoAppItemTests {
    // MARK: - Initialization Tests

    @Test("init with valid image creates item")
    func init_validImage_createsItem() {
        let image = createTestImage()
        let item = PhotoAppItem(name: "photo.png", image: image)

        #expect(item != nil)
        #expect(item?.name == "photo.png")
        #expect(item?.image === image)
    }

    @Test("init with nil image returns nil")
    func init_nilImage_returnsNil() {
        let item = PhotoAppItem(name: "photo.png", image: nil)

        #expect(item == nil)
    }

    @Test("init with empty name creates item")
    func init_emptyName_createsItem() {
        let image = createTestImage()
        let item = PhotoAppItem(name: "", image: image)

        #expect(item != nil)
        #expect(item?.name == "")
    }

    @Test("init preserves image reference")
    func init_preservesImageReference() {
        let image = createTestImage()
        let item = PhotoAppItem(name: "test", image: image)

        #expect(item?.image === image)
    }

    // MARK: - Name Property Tests

    @Test("name with special characters")
    func name_specialCharacters() {
        let image = createTestImage()
        let item = PhotoAppItem(name: "photo (1) - final!.jpg", image: image)

        #expect(item?.name == "photo (1) - final!.jpg")
    }

    @Test("name with unicode characters")
    func name_unicodeCharacters() {
        let image = createTestImage()
        let item = PhotoAppItem(name: "照片_2024.png", image: image)

        #expect(item?.name == "照片_2024.png")
    }

    @Test("name with emoji")
    func name_withEmoji() {
        let image = createTestImage()
        let item = PhotoAppItem(name: "🌅 Sunset.jpg", image: image)

        #expect(item?.name == "🌅 Sunset.jpg")
    }

    @Test("name with long string")
    func name_longString() {
        let image = createTestImage()
        let longName = String(repeating: "a", count: 255) + ".png"
        let item = PhotoAppItem(name: longName, image: image)

        #expect(item?.name == longName)
    }

    // MARK: - Equatable Tests

    @Test("items with same name are equal")
    func equatable_sameName_areEqual() {
        let image1 = createTestImage()
        let image2 = createTestImage()
        let item1 = PhotoAppItem(name: "photo.png", image: image1)
        let item2 = PhotoAppItem(name: "photo.png", image: image2)

        #expect(item1 == item2)
    }

    @Test("items with different names are not equal")
    func equatable_differentNames_notEqual() {
        let image = createTestImage()
        let item1 = PhotoAppItem(name: "photo1.png", image: image)
        let item2 = PhotoAppItem(name: "photo2.png", image: image)

        #expect(item1 != item2)
    }

    @Test("equality ignores image difference")
    func equatable_ignoresImageDifference() {
        let image1 = createTestImage(color: .red)
        let image2 = createTestImage(color: .blue)
        let item1 = PhotoAppItem(name: "same.png", image: image1)
        let item2 = PhotoAppItem(name: "same.png", image: image2)

        // Equality is based on name only
        #expect(item1 == item2)
    }

    @Test("equality is case sensitive")
    func equatable_caseSensitive() {
        let image = createTestImage()
        let item1 = PhotoAppItem(name: "Photo.png", image: image)
        let item2 = PhotoAppItem(name: "photo.png", image: image)

        #expect(item1 != item2)
    }

    @Test("equality with empty names")
    func equatable_emptyNames() {
        let image1 = createTestImage()
        let image2 = createTestImage()
        let item1 = PhotoAppItem(name: "", image: image1)
        let item2 = PhotoAppItem(name: "", image: image2)

        #expect(item1 == item2)
    }

    @Test("equality with whitespace differences")
    func equatable_whitespaceDifferences() {
        let image = createTestImage()
        let item1 = PhotoAppItem(name: "photo.png", image: image)
        let item2 = PhotoAppItem(name: "photo .png", image: image)

        #expect(item1 != item2)
    }

    // MARK: - Image Property Tests

    @Test("image property is accessible")
    func image_propertyAccessible() {
        let image = createTestImage(size: NSSize(width: 200, height: 200))
        let item = PhotoAppItem(name: "test", image: image)

        #expect(item?.image.size.width == 200)
        #expect(item?.image.size.height == 200)
    }

    // MARK: - Helpers

    private func createTestImage(size: NSSize = NSSize(width: 100, height: 100), color: NSColor = .red) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        image.unlockFocus()
        return image
    }
}
