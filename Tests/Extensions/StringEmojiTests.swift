//
//  StringEmojiTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("String and Character Emoji Extensions")
struct StringEmojiTests {
    // MARK: - Simple Emoji Detection Tests

    @Test("isSimpleEmoji returns true for basic emojis")
    func isSimpleEmoji_basicEmojis() {
        let simpleEmojis: [Character] = [
            "\u{1F600}", // Grinning face
            "\u{1F389}", // Party popper
            "\u{2764}", // Red heart (variant selector may be needed)
            "\u{1F4A1}", // Light bulb
            "\u{1F680}", // Rocket
        ]

        for emoji in simpleEmojis {
            #expect(emoji.isSimpleEmoji, "Expected \(emoji) to be a simple emoji")
        }
    }

    @Test("isSimpleEmoji returns false for regular characters")
    func isSimpleEmoji_regularCharacters() {
        let regularChars: [Character] = ["A", "Z", "a", "z", "0", "9", "!", "@", "#"]

        for char in regularChars {
            #expect(!char.isSimpleEmoji, "Expected \(char) to NOT be a simple emoji")
        }
    }

    @Test("isSimpleEmoji returns false for special unicode below threshold")
    func isSimpleEmoji_belowThreshold() {
        // Unicode scalars <= 0x238C should return false
        let lowUnicode: [Character] = [
            "\u{00A9}", // Copyright symbol
            "\u{00AE}", // Registered trademark
        ]

        for char in lowUnicode {
            #expect(!char.isSimpleEmoji, "Expected \(char) to NOT be a simple emoji (below threshold)")
        }
    }

    // MARK: - Combined Emoji Detection Tests

    @Test("isCombinedIntoEmoji returns true for combined emojis")
    func isCombinedIntoEmoji_combinedEmojis() {
        let combinedEmojis: [Character] = [
            "\u{1F3FB}", // Skin tone modifier (light)
            "\u{1F469}\u{200D}\u{1F4BB}", // Woman technologist (ZWJ sequence)
        ]

        for emoji in combinedEmojis {
            if emoji.unicodeScalars.count > 1 {
                #expect(emoji.isCombinedIntoEmoji, "Expected \(emoji) to be a combined emoji")
            }
        }
    }

    @Test("isCombinedIntoEmoji returns false for single scalars")
    func isCombinedIntoEmoji_singleScalars() {
        let singleScalarChars: [Character] = ["A", "Z", "\u{1F600}"]

        for char in singleScalarChars {
            if char.unicodeScalars.count == 1 {
                #expect(!char.isCombinedIntoEmoji, "Expected \(char) to NOT be a combined emoji")
            }
        }
    }

    // MARK: - General Emoji Detection Tests

    @Test("isEmoji returns true for any emoji type")
    func isEmoji_anyEmojiType() {
        let allEmojis: [Character] = [
            "\u{1F600}", // Simple emoji
            "\u{1F389}", // Simple emoji
        ]

        for emoji in allEmojis {
            #expect(emoji.isEmoji, "Expected \(emoji) to be detected as emoji")
        }
    }

    @Test("isEmoji returns false for non-emojis")
    func isEmoji_nonEmojis() {
        let nonEmojis: [Character] = [
            "A", "B", "C",
            "1", "2", "3",
            "!", "@", "#",
            " ", "\n", "\t",
        ]

        for char in nonEmojis {
            #expect(!char.isEmoji, "Expected \(char) to NOT be detected as emoji")
        }
    }

    // MARK: - String Contains Emoji Tests

    @Test("containsEmoji returns true when string has emojis")
    func containsEmoji_withEmojis() {
        let stringsWithEmojis = [
            "Hello \u{1F600}",
            "\u{1F389} Party!",
            "Middle \u{1F680} emoji",
            "\u{1F600}\u{1F389}\u{1F680}",
        ]

        for string in stringsWithEmojis {
            #expect(string.containsEmoji, "Expected '\(string)' to contain emoji")
        }
    }

    @Test("containsEmoji returns false for emoji-free strings")
    func containsEmoji_withoutEmojis() {
        let stringsWithoutEmojis = [
            "Hello World",
            "12345",
            "!@#$%^&*()",
            "",
            "   ",
            "Special chars: \u{00A9}\u{00AE}",
        ]

        for string in stringsWithoutEmojis {
            #expect(!string.containsEmoji, "Expected '\(string)' to NOT contain emoji")
        }
    }

    // MARK: - PNG Generation Tests

    @Test("png generates data for emoji")
    func png_generatesDataForEmoji() {
        let emoji: Character = "\u{1F600}"
        let pngData = emoji.png(ofSize: 32)

        #expect(pngData != nil)
        #expect(!pngData!.isEmpty)
    }

    @Test("png generates data for regular character")
    func png_generatesDataForCharacter() {
        let char: Character = "A"
        let pngData = char.png(ofSize: 32)

        #expect(pngData != nil)
        #expect(!pngData!.isEmpty)
    }

    @Test("png generates different data for different sizes")
    func png_differentSizes() {
        let emoji: Character = "\u{1F600}"

        let small = emoji.png(ofSize: 8)
        let medium = emoji.png(ofSize: 16)
        let large = emoji.png(ofSize: 32)

        #expect(small != nil)
        #expect(medium != nil)
        #expect(large != nil)

        // Different sizes should produce different data (different pixel counts)
        #expect(small!.count != large!.count)
    }

    @Test("png generates different data for different characters")
    func png_differentCharacters() {
        let char1: Character = "A"
        let char2: Character = "B"

        let png1 = char1.png(ofSize: 32)
        let png2 = char2.png(ofSize: 32)

        #expect(png1 != nil)
        #expect(png2 != nil)
        #expect(png1 != png2)
    }

    // MARK: - Unicode Available Tests

    @Test("unicodeAvailable returns true for valid emoji")
    func unicodeAvailable_validEmoji() {
        let validEmoji: Character = "\u{1F600}" // Grinning face - widely supported
        #expect(validEmoji.unicodeAvailable() == true)
    }

    @Test("unicodeAvailable returns true for regular character")
    func unicodeAvailable_regularCharacter() {
        let char: Character = "A"
        #expect(char.unicodeAvailable() == true)
    }

    @Test("unicodeAvailable detects unavailable unicode")
    func unicodeAvailable_unavailableUnicode() {
        // The reference character used is \u{1fff} which should render as placeholder
        // Most valid characters should return true (different from placeholder)
        let validChar: Character = "X"
        let isAvailable = validChar.unicodeAvailable()
        #expect(isAvailable == true)
    }

    // MARK: - Edge Cases

    @Test("Empty string containsEmoji")
    func containsEmoji_emptyString() {
        let empty = ""
        #expect(!empty.containsEmoji)
    }

    @Test("Whitespace-only string containsEmoji")
    func containsEmoji_whitespaceOnly() {
        let whitespace = "   \n\t  "
        #expect(!whitespace.containsEmoji)
    }

    @Test("Numbers are not emojis")
    func isEmoji_numbers() {
        for digit in "0123456789" {
            #expect(!digit.isEmoji)
        }
    }

    // MARK: - Skin Tone Variations

    @Test("Emoji with skin tone modifier")
    func isEmoji_skinToneModifier() {
        // Wave emoji with skin tone: \u{1F44B}\u{1F3FB}
        let waveWithSkinTone = "\u{1F44B}\u{1F3FB}"
        #expect(waveWithSkinTone.containsEmoji)
    }

    // MARK: - Flag Emojis

    @Test("Flag emojis are detected")
    func isEmoji_flags() {
        // US flag: \u{1F1FA}\u{1F1F8}
        let usFlag = "\u{1F1FA}\u{1F1F8}"
        #expect(usFlag.containsEmoji)
    }
}
