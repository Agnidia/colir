//
//  TestFixtures.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Foundation
@testable import colir

// MARK: - Image Fixtures

enum ImageFixtures {
    /// Create a solid color test image of specified size using CGContext (thread-safe)
    static func solidColorImage(size: NSSize, color: NSColor = .red) -> NSImage {
        TestImageFactory.solidColor(size: size, color: color)
    }

    /// Create a 16x16 test image
    static var image16x16: NSImage {
        solidColorImage(size: NSSize(width: 16, height: 16))
    }

    /// Create a 32x32 test image
    static var image32x32: NSImage {
        solidColorImage(size: NSSize(width: 32, height: 32))
    }

    /// Create a 128x128 test image
    static var image128x128: NSImage {
        solidColorImage(size: NSSize(width: 128, height: 128))
    }

    /// Create a 256x256 test image
    static var image256x256: NSImage {
        solidColorImage(size: NSSize(width: 256, height: 256))
    }

    /// Create a 512x512 test image
    static var image512x512: NSImage {
        solidColorImage(size: NSSize(width: 512, height: 512))
    }

    /// Create a complete icon set with all required sizes
    static var iconSet: [NSImage] {
        [
            image16x16,
            image32x32,
            image128x128,
            image256x256,
            image512x512,
        ]
    }
}

// MARK: - URL Fixtures

enum URLFixtures {
    /// Base temporary directory for tests
    static var testDirectory: URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("colir-tests-\(ProcessInfo.processInfo.processIdentifier)")
    }

    /// Sample Pictures folder for testing
    static var samplePicturesFolder: URL {
        testDirectory.appendingPathComponent("Pictures")
    }

    /// Create the test directory structure
    static func createTestDirectory() throws {
        try FileManager.default.createDirectory(at: testDirectory, withIntermediateDirectories: true)
    }

    /// Clean up the test directory
    static func cleanupTestDirectory() {
        try? FileManager.default.removeItem(at: testDirectory)
    }

    /// Create a temporary folder URL
    static func createTemporaryFolder(name: String = UUID().uuidString) throws -> URL {
        let folderURL = testDirectory.appendingPathComponent(name)
        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        return folderURL
    }

    /// Create a temporary file URL
    static func createTemporaryFile(name: String, content: Data = Data()) throws -> URL {
        let fileURL = testDirectory.appendingPathComponent(name)
        try FileManager.default.createDirectory(at: testDirectory, withIntermediateDirectories: true)
        try content.write(to: fileURL)
        return fileURL
    }
}

// MARK: - Color Fixtures

enum ColorFixtures {
    /// Pure red color
    static var red: NSColor { .red }

    /// Pure green color
    static var green: NSColor { .green }

    /// Pure blue color
    static var blue: NSColor { .blue }

    /// White color
    static var white: NSColor { .white }

    /// Black color
    static var black: NSColor { .black }

    /// Custom color with known hex value
    static var customColor: NSColor {
        NSColor(red: 0.5, green: 0.25, blue: 0.75, alpha: 1.0)
    }

    /// Array of test colors
    static var testColors: [NSColor] {
        [red, green, blue, white, black, customColor]
    }
}
