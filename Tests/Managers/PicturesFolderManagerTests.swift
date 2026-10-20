//
//  PicturesFolderManagerTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("PicturesFolderManager Tests")
struct PicturesFolderManagerTests {
    // MARK: - Initialization Tests

    @Test("init sets picturesDirectory correctly")
    func init_setsPicturesDirectory() {
        let url = URL(fileURLWithPath: "/tmp/test-pictures")
        let manager = PicturesFolderManager(picturesDirectory: url)

        #expect(manager.picturesDirectory == url)
    }

    @Test("init with home directory path")
    func init_homeDirectoryPath() {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        let picturesDir = homeDir.appendingPathComponent("Pictures")
        let manager = PicturesFolderManager(picturesDirectory: picturesDir)

        #expect(manager.picturesDirectory == picturesDir)
    }

    // MARK: - Protocol Conformance Tests

    @Test("conforms to PicturesFolderManagerProtocol")
    func conformsToProtocol() {
        let url = URL(fileURLWithPath: "/tmp")
        let manager: PicturesFolderManagerProtocol = PicturesFolderManager(picturesDirectory: url)

        #expect(manager.picturesDirectory == url)
    }

    // MARK: - readImages Tests (requires actual directory)

    @Test("readImages with empty directory returns empty array")
    func readImages_emptyDirectory() async throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let manager = PicturesFolderManager(picturesDirectory: tempDir)
        let images = try await manager.readImages()

        #expect(images.isEmpty)
    }

    @Test("readImages with non-image files returns empty array")
    func readImages_nonImageFiles() async throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        // Create non-image files
        let textFile = tempDir.appendingPathComponent("test.txt")
        try "test content".write(to: textFile, atomically: true, encoding: .utf8)

        let pdfFile = tempDir.appendingPathComponent("test.pdf")
        try Data().write(to: pdfFile)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let manager = PicturesFolderManager(picturesDirectory: tempDir)
        let images = try await manager.readImages()

        #expect(images.isEmpty)
    }

    @Test("readImages with valid image files returns items")
    func readImages_validImageFiles() async throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        // Create a valid PNG file
        let testImage = createTestImage()
        if let pngData = testImage.pngData {
            let imageFile = tempDir.appendingPathComponent("test.png")
            try pngData.write(to: imageFile)
        }

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let manager = PicturesFolderManager(picturesDirectory: tempDir)
        let images = try await manager.readImages()

        #expect(images.count == 1)
        #expect(images.first?.name == "test.png")
    }

    @Test("readImages filters by supported extensions")
    func readImages_filtersSupportedExtensions() async throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        // Create files with various extensions
        let testImage = createTestImage()
        if let pngData = testImage.pngData {
            try pngData.write(to: tempDir.appendingPathComponent("image.png"))
            try pngData.write(to: tempDir.appendingPathComponent("image.jpg"))
            try pngData.write(to: tempDir.appendingPathComponent("image.jpeg"))
            try pngData.write(to: tempDir.appendingPathComponent("image.gif"))
            try pngData.write(to: tempDir.appendingPathComponent("image.bmp"))
            try pngData.write(to: tempDir.appendingPathComponent("image.tiff")) // Not supported
            try pngData.write(to: tempDir.appendingPathComponent("image.webp")) // Not supported
        }

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let manager = PicturesFolderManager(picturesDirectory: tempDir)
        let images = try await manager.readImages()

        // Should only include png, jpg, jpeg, gif, bmp
        #expect(images.count == 5)
    }

    @Test("readImages handles case-insensitive extensions")
    func readImages_caseInsensitiveExtensions() async throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let testImage = createTestImage()
        if let pngData = testImage.pngData {
            try pngData.write(to: tempDir.appendingPathComponent("image.PNG"))
            try pngData.write(to: tempDir.appendingPathComponent("image.Jpg"))
            try pngData.write(to: tempDir.appendingPathComponent("image.JPEG"))
        }

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let manager = PicturesFolderManager(picturesDirectory: tempDir)
        let images = try await manager.readImages()

        #expect(images.count == 3)
    }

    @Test("readImages with invalid directory throws error")
    func readImages_invalidDirectory() async {
        let invalidDir = URL(fileURLWithPath: "/nonexistent/path/that/does/not/exist")
        let manager = PicturesFolderManager(picturesDirectory: invalidDir)

        do {
            _ = try await manager.readImages()
            Issue.record("Expected error to be thrown")
        } catch {
            // Expected behavior
            #expect(true)
        }
    }

    @Test("readImages returns items with correct names")
    func readImages_correctNames() async throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let testImage = createTestImage()
        if let pngData = testImage.pngData {
            try pngData.write(to: tempDir.appendingPathComponent("my_photo.png"))
            try pngData.write(to: tempDir.appendingPathComponent("vacation 2024.jpg"))
        }

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let manager = PicturesFolderManager(picturesDirectory: tempDir)
        let images = try await manager.readImages()

        let names = images.map(\.name)
        #expect(names.contains("my_photo.png"))
        #expect(names.contains("vacation 2024.jpg"))
    }

    // MARK: - Helpers

    private func createTestImage() -> NSImage {
        let image = NSImage(size: NSSize(width: 100, height: 100))
        image.lockFocus()
        NSColor.blue.drawSwatch(in: NSRect(origin: .zero, size: image.size))
        image.unlockFocus()
        return image
    }
}
