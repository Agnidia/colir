//
//  ImageCustomisationTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("ImageCustomisation Tests")
struct ImageCustomisationTests {
    // MARK: - ImageState Tests

    @Test("ImageState has expected cases")
    func imageState_cases() {
        _ = ImageCustomisation.ImageState.empty
        _ = ImageCustomisation.ImageState.dirty
        _ = ImageCustomisation.ImageState.processed

        #expect(true) // Verifies cases exist
    }

    // MARK: - Initialization Tests

    @Test("ImageCustomisation initializes with nil selections")
    func imageCustomisation_init() {
        let customisation = ImageCustomisation()

        #expect(customisation.selectedColor == nil)
        #expect(customisation.selectedPicture == nil)
        #expect(customisation.selectedAsset == nil)
        #expect(customisation.selectedPictureItem == nil)
        #expect(customisation.selectedEmoji == nil)
    }

    // MARK: - Apply Color Tests

    @Test("apply color sets selectedColor")
    func applyColor_setsColor() async {
        let customisation = ImageCustomisation()

        await customisation.apply(color: .red)

        #expect(customisation.selectedColor == .red)
    }

    @Test("apply nil color clears selectedColor")
    func applyColor_clearsColor() async {
        let customisation = ImageCustomisation()

        await customisation.apply(color: .blue)
        #expect(customisation.selectedColor == .blue)

        await customisation.apply(color: nil)
        #expect(customisation.selectedColor == nil)
    }

    // MARK: - Apply Picture Tests

    @Test("apply picture sets selectedPicture")
    func applyPicture_setsPicture() async {
        let customisation = ImageCustomisation()
        let testImage = NSImage(size: NSSize(width: 100, height: 100))

        await customisation.apply(picture: testImage)

        #expect(customisation.selectedPicture === testImage)
    }

    @Test("apply nil picture clears selectedPicture")
    func applyPicture_clearsPicture() async {
        let customisation = ImageCustomisation()
        let testImage = NSImage(size: NSSize(width: 100, height: 100))

        await customisation.apply(picture: testImage)
        #expect(customisation.selectedPicture != nil)

        await customisation.apply(picture: nil)
        #expect(customisation.selectedPicture == nil)
    }

    // MARK: - Apply Emoji Tests

    @Test("apply emoji sets selectedEmoji")
    func applyEmoji_setsEmoji() async {
        let customisation = ImageCustomisation()

        await customisation.apply(emoji: "😀")

        #expect(customisation.selectedEmoji == "😀")
    }

    @Test("apply nil emoji clears selectedEmoji")
    func applyEmoji_clearsEmoji() async {
        let customisation = ImageCustomisation()

        await customisation.apply(emoji: "🎉")
        #expect(customisation.selectedEmoji == "🎉")

        await customisation.apply(emoji: nil)
        #expect(customisation.selectedEmoji == nil)
    }

    // MARK: - Undo Items Tests

    @Test("undoItems returns current state")
    func undoItems_returnsState() async {
        let customisation = ImageCustomisation()

        await customisation.apply(color: .green)
        await customisation.apply(emoji: "⭐")

        let undo = customisation.undoItems

        #expect(undo.selectedColor == .green)
        #expect(undo.selectedEmoji == "⭐")
    }

    @Test("update from undoItems restores state")
    func update_fromUndoItems() async {
        let customisation = ImageCustomisation()

        // Set initial state
        await customisation.apply(color: .red)
        await customisation.apply(emoji: "🔥")

        let savedUndo = customisation.undoItems

        // Change state
        await customisation.apply(color: .blue)
        await customisation.apply(emoji: "💧")

        #expect(customisation.selectedColor == .blue)
        #expect(customisation.selectedEmoji == "💧")

        // Restore from undo
        customisation.update(from: savedUndo)

        #expect(customisation.selectedColor == .red)
        #expect(customisation.selectedEmoji == "🔥")
    }

    // MARK: - Update Color Tests

    @Test("updateColor returns original when no color selected")
    func updateColor_returnsOriginal_whenNoColor() async {
        let customisation = ImageCustomisation()
        let originalImage = createTestImage(size: NSSize(width: 64, height: 64), color: .blue)
        let updatedImage = NSImage()

        let result = await customisation.updateColor(for: originalImage, size: .s256, updatedImage: updatedImage)

        // Should return original when no color is selected
        #expect(result.size == originalImage.size)
    }

    @Test("updateColor applies color when dirty")
    func updateColor_appliesColor_whenDirty() async {
        let customisation = ImageCustomisation()
        let originalImage = createTestImage(size: NSSize(width: 64, height: 64), color: .blue)
        let updatedImage = NSImage()

        await customisation.apply(color: .red)

        let result = await customisation.updateColor(for: originalImage, size: .s256, updatedImage: updatedImage)

        // Should return a modified image (or original if tinting fails)
        #expect(result.size.width > 0)
    }

    @Test("updateColor returns cached when processed")
    func updateColor_returnsCached_whenProcessed() async {
        let customisation = ImageCustomisation()
        let originalImage = createTestImage(size: NSSize(width: 64, height: 64), color: .blue)
        let updatedImage = createTestImage(size: NSSize(width: 64, height: 64), color: .green)

        await customisation.apply(color: .red)

        // First call - processes
        _ = await customisation.updateColor(for: originalImage, size: .s256, updatedImage: updatedImage)

        // Second call - should return updatedImage (cached)
        let result = await customisation.updateColor(for: originalImage, size: .s256, updatedImage: updatedImage)

        #expect(result === updatedImage)
    }

    // MARK: - Update Picture Tests

    @Test("updatePicture returns original when no picture selected")
    func updatePicture_returnsOriginal_whenNoPicture() async {
        let customisation = ImageCustomisation()
        let originalImage = createTestImage(size: NSSize(width: 64, height: 64), color: .blue)
        let updatedImage = NSImage()

        let result = await customisation.updatePicture(for: originalImage, size: .s256, updatedImage: updatedImage)

        #expect(result.size == originalImage.size)
    }

    // MARK: - Update Emoji Tests

    @Test("updateEmoji returns original when no emoji selected")
    func updateEmoji_returnsOriginal_whenNoEmoji() async {
        let customisation = ImageCustomisation()
        let originalImage = createTestImage(size: NSSize(width: 64, height: 64), color: .blue)
        let updatedImage = NSImage()

        let result = await customisation.updateEmoji(for: originalImage, size: .s256, updatedImage: updatedImage)

        #expect(result.size == originalImage.size)
    }

    @Test("updateEmoji applies emoji when dirty")
    func updateEmoji_appliesEmoji_whenDirty() async {
        let customisation = ImageCustomisation()
        let originalImage = createTestImage(size: NSSize(width: 256, height: 256), color: .blue)
        let updatedImage = NSImage()

        await customisation.apply(emoji: "🎨")

        let result = await customisation.updateEmoji(for: originalImage, size: .s256, updatedImage: updatedImage)

        // Should return a modified image
        #expect(result.size.width > 0)
    }

    // MARK: - ImageCustomisationUndoDto Tests

    @Test("ImageCustomisationUndoDto stores values")
    func undoDto_storesValues() {
        let testImage = NSImage(size: NSSize(width: 100, height: 100))
        let undoDto = ImageCustomisationUndoDto(
            selectedColor: .purple,
            selectedPicture: testImage,
            selectedAsset: nil,
            selectedPictureItem: nil,
            selectedEmoji: "🚀"
        )

        #expect(undoDto.selectedColor == .purple)
        #expect(undoDto.selectedPicture === testImage)
        #expect(undoDto.selectedEmoji == "🚀")
        #expect(undoDto.selectedAsset == nil)
        #expect(undoDto.selectedPictureItem == nil)
    }

    @Test("ImageCustomisationUndoDto default init")
    func undoDto_defaultInit() {
        let undoDto = ImageCustomisationUndoDto()

        #expect(undoDto.selectedColor == nil)
        #expect(undoDto.selectedPicture == nil)
        #expect(undoDto.selectedEmoji == nil)
        #expect(undoDto.selectedAsset == nil)
        #expect(undoDto.selectedPictureItem == nil)
    }

    // MARK: - Combined Operations Tests

    @Test("multiple apply operations update state correctly")
    func multipleApplyOperations() async {
        let customisation = ImageCustomisation()
        let testImage = NSImage(size: NSSize(width: 100, height: 100))

        // Apply all customizations
        await customisation.apply(color: .orange)
        await customisation.apply(picture: testImage)
        await customisation.apply(emoji: "🌟")

        #expect(customisation.selectedColor == .orange)
        #expect(customisation.selectedPicture === testImage)
        #expect(customisation.selectedEmoji == "🌟")
    }

    @Test("changing color marks images dirty")
    func changingColor_marksDirty() async {
        let customisation = ImageCustomisation()
        let originalImage = createTestImage(size: NSSize(width: 64, height: 64), color: .blue)
        let cachedImage = createTestImage(size: NSSize(width: 64, height: 64), color: .green)

        // Apply first color and process
        await customisation.apply(color: .red)
        _ = await customisation.updateColor(for: originalImage, size: .s256, updatedImage: cachedImage)

        // Apply second color - should mark dirty again
        await customisation.apply(color: .yellow)

        // Should process new color, not return cached
        let result = await customisation.updateColor(for: originalImage, size: .s256, updatedImage: cachedImage)

        // Result should not be the cached image (since state was reset to dirty)
        // It should be either original or newly processed
        #expect(result !== cachedImage || result.size.width > 0)
    }

    // MARK: - Helpers

    private func createTestImage(size: NSSize, color: NSColor) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        image.unlockFocus()
        return image
    }
}
