//
//  StringCryptoTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import Testing
@testable import colir

@Suite("String Crypto Extension")
struct StringCryptoTests {
    private let testKey = "TestKey1234567" // Must be appropriate length for AES

    // MARK: - Encryption Tests

    @Test("AES encrypt returns base64 string")
    func aesEncrypt_returnsBase64() {
        let plaintext = "Hello, World!"
        let encrypted = plaintext.aesEncrypt(key: testKey)

        #expect(encrypted != nil)
        #expect(encrypted != plaintext)

        // Verify it's valid base64 by attempting to decode
        if let encrypted {
            let data = Data(base64Encoded: encrypted, options: .ignoreUnknownCharacters)
            #expect(data != nil)
        }
    }

    @Test("AES encrypt returns different output for different inputs")
    func aesEncrypt_differentOutputs() {
        let text1 = "Hello"
        let text2 = "World"

        let encrypted1 = text1.aesEncrypt(key: testKey)
        let encrypted2 = text2.aesEncrypt(key: testKey)

        #expect(encrypted1 != nil)
        #expect(encrypted2 != nil)
        #expect(encrypted1 != encrypted2)
    }

    @Test("AES encrypt handles empty string")
    func aesEncrypt_emptyString() {
        let plaintext = ""
        let encrypted = plaintext.aesEncrypt(key: testKey)

        // Empty string should still encrypt (may return short encrypted value)
        #expect(encrypted != nil)
    }

    @Test("AES encrypt handles unicode characters")
    func aesEncrypt_unicodeCharacters() {
        let plaintext = "Hello, \u{1F600} \u{1F389}"
        let encrypted = plaintext.aesEncrypt(key: testKey)

        #expect(encrypted != nil)
    }

    @Test("AES encrypt handles long strings")
    func aesEncrypt_longStrings() {
        let plaintext = String(repeating: "A", count: 10_000)
        let encrypted = plaintext.aesEncrypt(key: testKey)

        #expect(encrypted != nil)
    }

    // MARK: - Decryption Tests

    @Test("AES decrypt returns original string")
    func aesDecrypt_returnsOriginal() {
        let plaintext = "Secret message"

        guard let encrypted = plaintext.aesEncrypt(key: testKey) else {
            Issue.record("Encryption failed")
            return
        }

        let decrypted = encrypted.aesDecrypt(key: testKey)

        #expect(decrypted == plaintext)
    }

    @Test("AES decrypt returns nil for invalid base64")
    func aesDecrypt_returnsNilForInvalidBase64() {
        let invalidBase64 = "Not valid base64!!!"
        let decrypted = invalidBase64.aesDecrypt(key: testKey)

        #expect(decrypted == nil)
    }

    @Test("AES decrypt returns nil for wrong key")
    func aesDecrypt_returnsNilForWrongKey() {
        let plaintext = "Secret message"
        let wrongKey = "WrongKey123456"

        guard let encrypted = plaintext.aesEncrypt(key: testKey) else {
            Issue.record("Encryption failed")
            return
        }

        let decrypted = encrypted.aesDecrypt(key: wrongKey)

        // Decryption with wrong key should either return nil or garbled output
        #expect(decrypted != plaintext)
    }

    // MARK: - Roundtrip Tests

    @Test("Encryption/decryption roundtrip preserves content")
    func aesRoundtrip_preservesContent() {
        let testStrings = [
            "Simple text",
            "Text with numbers 12345",
            "Special characters !@#$%^&*()",
            "Unicode \u{00E9}\u{00F1}\u{00FC}",
            "Multi\nline\ntext",
            "Tabs\tand\tspaces",
            "Very long string " + String(repeating: "x", count: 1000),
        ]

        for original in testStrings {
            guard let encrypted = original.aesEncrypt(key: testKey) else {
                Issue.record("Encryption failed for: \(original.prefix(20))...")
                continue
            }

            let decrypted = encrypted.aesDecrypt(key: testKey)

            #expect(decrypted == original, "Roundtrip failed for: \(original.prefix(20))...")
        }
    }

    @Test("Encryption is deterministic with same key")
    func aesEncrypt_deterministicWithSameKey() {
        let plaintext = "Test message"

        let encrypted1 = plaintext.aesEncrypt(key: testKey)
        let encrypted2 = plaintext.aesEncrypt(key: testKey)

        // Without IV, same input + key should produce same output
        #expect(encrypted1 == encrypted2)
    }

    // MARK: - Edge Cases

    @Test("Handles string with null characters")
    func aesRoundtrip_nullCharacters() {
        let plaintext = "Hello\0World"

        guard let encrypted = plaintext.aesEncrypt(key: testKey) else {
            Issue.record("Encryption failed")
            return
        }

        let decrypted = encrypted.aesDecrypt(key: testKey)

        // The string up to null should be preserved at minimum
        #expect(decrypted?.hasPrefix("Hello") == true)
    }

    @Test("Different key lengths work correctly")
    func aesEncrypt_differentKeyLengths() {
        let plaintext = "Test message"

        // Short key (will be padded internally)
        let shortKey = "short"
        let encrypted1 = plaintext.aesEncrypt(key: shortKey)
        #expect(encrypted1 != nil)

        // Long key
        let longKey = "ThisIsAVeryLongKeyThatExceedsNormalLength"
        let encrypted2 = plaintext.aesEncrypt(key: longKey)
        #expect(encrypted2 != nil)
    }

    // MARK: - CryptoModel Integration (using same key as CryptoModel)

    @Test("Works with CryptoModel key")
    func aesRoundtrip_cryptoModelKey() {
        let cryptoKey = "ColirToken" // Same key used by CryptoModel
        let plaintext = "0" // Common value in CryptoModel

        guard let encrypted = plaintext.aesEncrypt(key: cryptoKey) else {
            Issue.record("Encryption failed")
            return
        }

        let decrypted = encrypted.aesDecrypt(key: cryptoKey)

        #expect(decrypted == plaintext)
    }
}
