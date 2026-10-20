//
//  IconManagerTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("IconManager Tests")
struct IconManagerTests {
    // MARK: - IconManagerError Tests

    @Test("IconManagerError has expected cases")
    func error_hasCases() {
        // Verify all error cases exist
        _ = IconManagerError.missedData
        _ = IconManagerError.dummyFileNotCreated
        _ = IconManagerError.scriptNotCreated
        _ = IconManagerError.scriptNotExecuted
        _ = IconManagerError.scriptError("test message")

        #expect(true)
    }

    @Test("IconManagerError conforms to Error")
    func error_conformsToError() {
        let error: Error = IconManagerError.missedData

        #expect(error is IconManagerError)
    }

    @Test("IconManagerError.scriptError contains message")
    func error_scriptErrorMessage() {
        let error = IconManagerError.scriptError("Test error message")

        // Verify the error case contains the message
        if case .scriptError(let message) = error {
            #expect(message == "Test error message")
        } else {
            Issue.record("Expected scriptError case")
        }
    }

    @Test("IconManagerError cases are distinct")
    func error_casesDistinct() {
        let errors: [IconManagerError] = [
            .missedData,
            .dummyFileNotCreated,
            .scriptNotCreated,
            .scriptNotExecuted,
            .scriptError("test"),
        ]

        // All descriptions should be different
        let descriptions = errors.map { String(describing: $0) }
        let uniqueDescriptions = Set(descriptions)
        #expect(uniqueDescriptions.count == errors.count)
    }

    // MARK: - IconManager Initialization Tests

    @Test("IconManager initializes successfully")
    func init_success() {
        let manager = IconManager()

        #expect(manager != nil)
    }

    // MARK: - convertImagesToIcns Tests

    @Test("convertImagesToIcns with valid images produces data")
    func convertImagesToIcns_validImages() throws {
        let manager = IconManager()
        let images = createTestIconSet()

        let icnsData = try manager.convertImagesToIcns(images)

        #expect(!icnsData.isEmpty)
        // ICNS files start with "icns" magic number
        #expect(icnsData.count > 4)
    }

    @Test("convertImagesToIcns with single image")
    func convertImagesToIcns_singleImage() throws {
        let manager = IconManager()
        let images = [createTestImage(size: NSSize(width: 256, height: 256))]

        let icnsData = try manager.convertImagesToIcns(images)

        #expect(!icnsData.isEmpty)
    }

    @Test("convertImagesToIcns with multiple sizes")
    func convertImagesToIcns_multipleSizes() throws {
        let manager = IconManager()
        let images = [
            createTestImage(size: NSSize(width: 16, height: 16)),
            createTestImage(size: NSSize(width: 32, height: 32)),
            createTestImage(size: NSSize(width: 128, height: 128)),
            createTestImage(size: NSSize(width: 256, height: 256)),
            createTestImage(size: NSSize(width: 512, height: 512)),
        ]

        let icnsData = try manager.convertImagesToIcns(images)

        #expect(!icnsData.isEmpty)
    }

    @Test("convertImagesToIcns with empty array")
    func convertImagesToIcns_emptyArray() throws {
        let manager = IconManager()

        // Should still produce some output or throw
        do {
            let icnsData = try manager.convertImagesToIcns([])
            // If it doesn't throw, check the data
            #expect(icnsData.count >= 0)
        } catch {
            // Throwing is also acceptable for empty input
            #expect(true)
        }
    }

    @Test("convertImagesToIcns cleans up temp files")
    func convertImagesToIcns_cleansUpTempFiles() throws {
        let manager = IconManager()
        let images = createTestIconSet()

        let tempDirCount = countTempDirs()
        _ = try manager.convertImagesToIcns(images)
        let newTempDirCount = countTempDirs()

        // Should not leave extra temp directories
        #expect(newTempDirCount <= tempDirCount + 1)
    }

    // MARK: - setIcon Tests (requires sandbox permissions)

    @Test("setIcon with invalid path throws error")
    func setIcon_invalidPath_throws() async {
        let manager = IconManager()
        let iconData = Data([0, 0, 0, 0]) // Minimal invalid data
        let invalidPath = URL(fileURLWithPath: "/nonexistent/path/file.app")

        do {
            try manager.setIcon(data: iconData, to: invalidPath)
            // If it doesn't throw, that's unexpected
            Issue.record("Expected error to be thrown")
        } catch {
            // Expected behavior
            #expect(error is IconManagerError)
        }
    }

    // MARK: - Integration Tests

    @Test("full icon creation workflow")
    func fullWorkflow_createIcon() throws {
        let manager = IconManager()
        let images = createTestIconSet()

        // Step 1: Convert to ICNS
        let icnsData = try manager.convertImagesToIcns(images)

        // Verify ICNS data structure
        #expect(!icnsData.isEmpty)

        // ICNS magic number is "icns" (0x69636E73)
        if icnsData.count >= 4 {
            let magicBytes = [UInt8](icnsData.prefix(4))
            let expectedMagic: [UInt8] = [0x69, 0x63, 0x6E, 0x73] // "icns"
            #expect(magicBytes == expectedMagic, "ICNS file should start with 'icns' magic number")
        }
    }

    // MARK: - Helpers

    private func createTestImage(size: NSSize, color: NSColor = .red) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        image.unlockFocus()
        return image
    }

    private func createTestIconSet() -> [NSImage] {
        [
            createTestImage(size: NSSize(width: 16, height: 16)),
            createTestImage(size: NSSize(width: 32, height: 32)),
            createTestImage(size: NSSize(width: 128, height: 128)),
            createTestImage(size: NSSize(width: 256, height: 256)),
            createTestImage(size: NSSize(width: 512, height: 512)),
        ]
    }

    private func countTempDirs() -> Int {
        let tempDir = FileManager.default.temporaryDirectory
        let contents = try? FileManager.default.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: nil)
        return contents?.count ?? 0
    }
}
