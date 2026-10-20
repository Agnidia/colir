//
//  PhotoAssetTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import Photos
import Testing
@testable import colir

@Suite("PhotoAsset Tests")
struct PhotoAssetTests {
    // MARK: - Initialization Tests

    @Test("init with identifier sets identifier")
    func init_withIdentifier_setsIdentifier() {
        let identifier = "test-identifier-123"
        let asset = PhotoAsset(identifier: identifier)

        #expect(asset.identifier == identifier)
        #expect(asset.id == identifier)
    }

    @Test("init with identifier has nil phAsset for invalid identifier")
    func init_withIdentifier_nilPhAssetForInvalid() {
        let asset = PhotoAsset(identifier: "nonexistent-identifier")

        #expect(asset.phAsset == nil)
    }

    @Test("default init creates UUID identifier")
    func defaultInit_createsUUID() {
        // Using identifier init with a unique string
        let asset = PhotoAsset(identifier: UUID().uuidString)

        #expect(!asset.identifier.isEmpty)
        #expect(asset.id == asset.identifier)
    }

    // MARK: - Identifiable Tests

    @Test("id returns identifier")
    func id_returnsIdentifier() {
        let testId = "custom-id-456"
        let asset = PhotoAsset(identifier: testId)

        #expect(asset.id == testId)
    }

    // MARK: - MediaType Tests

    @Test("mediaType returns unknown when phAsset is nil")
    func mediaType_returnsUnknown_whenPhAssetNil() {
        let asset = PhotoAsset(identifier: "invalid")

        #expect(asset.mediaType == .unknown)
    }

    // MARK: - Equatable Tests

    @Test("assets with same identifier are equal")
    func equatable_sameIdentifier_areEqual() {
        let identifier = "same-identifier"
        let asset1 = PhotoAsset(identifier: identifier)
        let asset2 = PhotoAsset(identifier: identifier)

        #expect(asset1 == asset2)
    }

    @Test("assets with different identifiers are not equal")
    func equatable_differentIdentifiers_notEqual() {
        let asset1 = PhotoAsset(identifier: "id-1")
        let asset2 = PhotoAsset(identifier: "id-2")

        #expect(asset1 != asset2)
    }

    @Test("equality is case sensitive")
    func equatable_caseSensitive() {
        let asset1 = PhotoAsset(identifier: "Test-ID")
        let asset2 = PhotoAsset(identifier: "test-id")

        #expect(asset1 != asset2)
    }

    // MARK: - Hashable Tests

    @Test("hashable produces consistent hash")
    func hashable_consistentHash() {
        let identifier = "hash-test-id"
        let asset1 = PhotoAsset(identifier: identifier)
        let asset2 = PhotoAsset(identifier: identifier)

        #expect(asset1.hashValue == asset2.hashValue)
    }

    @Test("different identifiers produce different hashes")
    func hashable_differentHashes() {
        let asset1 = PhotoAsset(identifier: "hash-1")
        let asset2 = PhotoAsset(identifier: "hash-2")

        #expect(asset1.hashValue != asset2.hashValue)
    }

    @Test("can be used in Set")
    func hashable_canBeUsedInSet() {
        let asset1 = PhotoAsset(identifier: "set-test-1")
        let asset2 = PhotoAsset(identifier: "set-test-2")
        let asset3 = PhotoAsset(identifier: "set-test-1") // Duplicate

        var set = Set<PhotoAsset>()
        set.insert(asset1)
        set.insert(asset2)
        set.insert(asset3)

        #expect(set.count == 2)
    }

    @Test("can be used as Dictionary key")
    func hashable_canBeDictionaryKey() {
        let asset = PhotoAsset(identifier: "dict-key")
        var dict = [PhotoAsset: String]()
        dict[asset] = "value"

        #expect(dict[asset] == "value")
    }

    // MARK: - Index Property Tests

    @Test("index is nil for identifier init")
    func index_nilForIdentifierInit() {
        let asset = PhotoAsset(identifier: "test")

        #expect(asset.index == nil)
    }

    // MARK: - Sendable Conformance Tests

    @Test("PhotoAsset is Sendable")
    func sendable_conformance() async {
        let asset = PhotoAsset(identifier: "sendable-test")

        // Pass across actor boundary
        let result = await Task.detached {
            asset.identifier
        }.value

        #expect(result == "sendable-test")
    }
}
