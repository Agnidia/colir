//
//  PicturesFolderItemTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("PicturesFolderItem Tests")
struct PicturesFolderItemTests {
    // MARK: - Initialization Tests

    @Test("init with valid image creates item")
    func init_validImage_createsItem() {
        let image = createTestImage()
        let item = PicturesFolderItem(name: "test.png", image: image)

        #expect(item != nil)
        #expect(item?.name == "test.png")
        #expect(item?.image === image)
    }

    @Test("init with nil image returns nil")
    func init_nilImage_returnsNil() {
        let item = PicturesFolderItem(name: "test.png", image: nil)

        #expect(item == nil)
    }

    @Test("init with empty name creates item")
    func init_emptyName_createsItem() {
        let image = createTestImage()
        let item = PicturesFolderItem(name: "", image: image)

        #expect(item != nil)
        #expect(item?.name == "")
    }

    @Test("init with special characters in name")
    func init_specialCharactersInName() {
        let image = createTestImage()
        let item = PicturesFolderItem(name: "test file (1)!@#.png", image: image)

        #expect(item != nil)
        #expect(item?.name == "test file (1)!@#.png")
    }

    @Test("init with unicode name")
    func init_unicodeName() {
        let image = createTestImage()
        let item = PicturesFolderItem(name: "日本語ファイル.png", image: image)

        #expect(item != nil)
        #expect(item?.name == "日本語ファイル.png")
    }

    // MARK: - Equatable Tests

    @Test("items with same name are equal")
    func equatable_sameName_areEqual() {
        let image1 = createTestImage()
        let image2 = createTestImage()
        let item1 = PicturesFolderItem(name: "test.png", image: image1)
        let item2 = PicturesFolderItem(name: "test.png", image: image2)

        #expect(item1 == item2)
    }

    @Test("items with different names are not equal")
    func equatable_differentNames_notEqual() {
        let image = createTestImage()
        let item1 = PicturesFolderItem(name: "test1.png", image: image)
        let item2 = PicturesFolderItem(name: "test2.png", image: image)

        #expect(item1 != item2)
    }

    @Test("items with same image but different names are not equal")
    func equatable_sameImageDifferentNames_notEqual() {
        let image = createTestImage()
        let item1 = PicturesFolderItem(name: "original.png", image: image)
        let item2 = PicturesFolderItem(name: "copy.png", image: image)

        #expect(item1 != item2)
    }

    @Test("equality is case sensitive")
    func equatable_caseSensitive() {
        let image = createTestImage()
        let item1 = PicturesFolderItem(name: "Test.png", image: image)
        let item2 = PicturesFolderItem(name: "test.png", image: image)

        #expect(item1 != item2)
    }

    // MARK: - Property Access Tests

    @Test("name property returns correct value")
    func name_returnsCorrectValue() {
        let image = createTestImage()
        let item = PicturesFolderItem(name: "myimage.jpg", image: image)

        #expect(item?.name == "myimage.jpg")
    }

    @Test("image property returns correct reference")
    func image_returnsCorrectReference() {
        let image = createTestImage()
        let item = PicturesFolderItem(name: "test.png", image: image)

        #expect(item?.image === image)
    }

    // MARK: - Helpers

    private func createTestImage() -> NSImage {
        let image = NSImage(size: NSSize(width: 100, height: 100))
        image.lockFocus()
        NSColor.red.drawSwatch(in: NSRect(origin: .zero, size: image.size))
        image.unlockFocus()
        return image
    }
}
