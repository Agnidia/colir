//
//  NSImageDrawTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("NSImage Draw Extension")
struct NSImageDrawTests {
    // MARK: - draw(image:at:) Tests

    @Test("draw image at default position returns new image")
    func drawImage_defaultPosition_returnsNewImage() {
        let baseImage = createTestImage(size: NSSize(width: 100, height: 100), color: .red)
        let overlayImage = createTestImage(size: NSSize(width: 50, height: 50), color: .blue)

        let result = baseImage.draw(image: overlayImage)

        #expect(result.size == baseImage.size)
        #expect(result !== baseImage)
    }

    @Test("draw image at custom position")
    func drawImage_customPosition() {
        let baseImage = createTestImage(size: NSSize(width: 100, height: 100), color: .red)
        let overlayImage = createTestImage(size: NSSize(width: 50, height: 50), color: .blue)

        let result = baseImage.draw(image: overlayImage, at: CGPoint(x: 25, y: 25))

        #expect(result.size == baseImage.size)
    }

    @Test("draw image at zero position")
    func drawImage_zeroPosition() {
        let baseImage = createTestImage(size: NSSize(width: 100, height: 100), color: .red)
        let overlayImage = createTestImage(size: NSSize(width: 100, height: 100), color: .blue)

        let result = baseImage.draw(image: overlayImage, at: .zero)

        #expect(result.size == baseImage.size)
    }

    @Test("draw image preserves base image size")
    func drawImage_preservesBaseSize() {
        let baseImage = createTestImage(size: NSSize(width: 256, height: 256), color: .red)
        let overlayImage = createTestImage(size: NSSize(width: 512, height: 512), color: .blue)

        let result = baseImage.draw(image: overlayImage)

        #expect(result.size.width == 256)
        #expect(result.size.height == 256)
    }

    @Test("draw smaller image onto larger image")
    func drawImage_smallerOntoLarger() {
        let baseImage = createTestImage(size: NSSize(width: 200, height: 200), color: .green)
        let overlayImage = createTestImage(size: NSSize(width: 50, height: 50), color: .yellow)

        let result = baseImage.draw(image: overlayImage, at: CGPoint(x: 75, y: 75))

        #expect(result.size == baseImage.size)
    }

    // MARK: - draw(emoji:) Tests

    @Test("draw emoji returns new image")
    func drawEmoji_returnsNewImage() {
        let baseImage = createTestImage(size: NSSize(width: 512, height: 512), color: .white)
        let emoji: Character = "😀"

        let result = baseImage.draw(emoji: emoji)

        #expect(result.size == baseImage.size)
        #expect(result !== baseImage)
    }

    @Test("draw emoji on different sizes")
    func drawEmoji_differentSizes() {
        let sizes: [CGFloat] = [16, 32, 64, 128, 256, 512]

        for size in sizes {
            let baseImage = createTestImage(size: NSSize(width: size, height: size), color: .white)
            let emoji: Character = "🎨"

            let result = baseImage.draw(emoji: emoji)

            #expect(result.size.width == size, "Width should match for size \(size)")
            #expect(result.size.height == size, "Height should match for size \(size)")
        }
    }

    @Test("draw emoji 16x16 size")
    func drawEmoji_16x16() {
        let baseImage = createTestImage(size: NSSize(width: 16, height: 16), color: .white)
        let emoji: Character = "⭐"

        let result = baseImage.draw(emoji: emoji)

        #expect(result.size.width == 16)
        #expect(result.size.height == 16)
    }

    @Test("draw emoji 32x32 size")
    func drawEmoji_32x32() {
        let baseImage = createTestImage(size: NSSize(width: 32, height: 32), color: .white)
        let emoji: Character = "🔥"

        let result = baseImage.draw(emoji: emoji)

        #expect(result.size.width == 32)
        #expect(result.size.height == 32)
    }

    @Test("draw different emojis")
    func drawEmoji_differentEmojis() {
        let emojis: [Character] = ["😀", "🎉", "🚀", "💡", "🎨", "⭐"]
        let baseSize = NSSize(width: 64, height: 64)

        for emoji in emojis {
            let baseImage = createTestImage(size: baseSize, color: .white)
            let result = baseImage.draw(emoji: emoji)

            #expect(result.size == baseSize, "Size should be preserved for emoji \(emoji)")
        }
    }

    @Test("draw emoji with skin tone modifier")
    func drawEmoji_skinToneModifier() {
        let baseImage = createTestImage(size: NSSize(width: 128, height: 128), color: .white)
        // Wave emoji with skin tone
        let emoji = Character("👋🏻")

        let result = baseImage.draw(emoji: emoji)

        #expect(result.size == baseImage.size)
    }

    @Test("draw combined emoji (ZWJ sequence)")
    func drawEmoji_zwjSequence() {
        let baseImage = createTestImage(size: NSSize(width: 128, height: 128), color: .white)
        // Woman technologist (ZWJ sequence)
        let emoji = Character("👩‍💻")

        let result = baseImage.draw(emoji: emoji)

        #expect(result.size == baseImage.size)
    }

    @Test("draw flag emoji")
    func drawEmoji_flagEmoji() {
        let baseImage = createTestImage(size: NSSize(width: 128, height: 128), color: .white)
        // US flag
        let emoji = Character("🇺🇸")

        let result = baseImage.draw(emoji: emoji)

        #expect(result.size == baseImage.size)
    }

    // MARK: - Edge Cases

    @Test("draw image multiple times")
    func drawImage_multipleDraws() {
        var image = createTestImage(size: NSSize(width: 100, height: 100), color: .red)
        let overlay = createTestImage(size: NSSize(width: 50, height: 50), color: .blue)

        image = image.draw(image: overlay, at: CGPoint(x: 0, y: 0))
        image = image.draw(image: overlay, at: CGPoint(x: 25, y: 25))
        image = image.draw(image: overlay, at: CGPoint(x: 50, y: 50))

        #expect(image.size.width == 100)
        #expect(image.size.height == 100)
    }

    @Test("draw emoji then image")
    func drawEmoji_thenDrawImage() {
        let baseImage = createTestImage(size: NSSize(width: 128, height: 128), color: .white)
        let overlay = createTestImage(size: NSSize(width: 64, height: 64), color: .blue)
        let emoji: Character = "🎉"

        var result = baseImage.draw(emoji: emoji)
        result = result.draw(image: overlay, at: CGPoint(x: 32, y: 32))

        #expect(result.size == baseImage.size)
    }

    // MARK: - Helpers

    private func createTestImage(size: NSSize, color: NSColor = .red) -> NSImage {
        TestImageFactory.solidColor(size: size, color: color)
    }
}
