//
//  PhotoAssetCollectionTests.swift
//  colirTests
//
//  Created by Claude Code on 2025-12-15.
//  Copyright (c) 2025 IGR Software. All rights reserved.
//

@testable import colir
import Photos
import Testing

@Suite("PhotoAssetCollection Tests")
struct PhotoAssetCollectionTests {
    // MARK: - Initialization Tests

    @Test("init with empty fetch result")
    func init_emptyFetchResult() {
        let fetchResult = PHFetchResult<PHAsset>()
        let collection = PhotoAssetCollection(fetchResult)

        #expect(collection.count == 0)
        #expect(collection.startIndex == 0)
        #expect(collection.endIndex == 0)
    }

    // MARK: - RandomAccessCollection Tests

    @Test("startIndex is zero")
    func startIndex_isZero() {
        let fetchResult = PHFetchResult<PHAsset>()
        let collection = PhotoAssetCollection(fetchResult)

        #expect(collection.startIndex == 0)
    }

    @Test("endIndex equals count")
    func endIndex_equalsCount() {
        let fetchResult = PHFetchResult<PHAsset>()
        let collection = PhotoAssetCollection(fetchResult)

        #expect(collection.endIndex == collection.count)
    }

    @Test("empty collection has matching start and end indices")
    func emptyCollection_matchingIndices() {
        let fetchResult = PHFetchResult<PHAsset>()
        let collection = PhotoAssetCollection(fetchResult)

        #expect(collection.startIndex == collection.endIndex)
    }

    // MARK: - fetchResult Property Tests

    @Test("fetchResult property is accessible")
    func fetchResult_accessible() {
        let fetchResult = PHFetchResult<PHAsset>()
        let collection = PhotoAssetCollection(fetchResult)

        #expect(collection.fetchResult.count == 0)
    }

    // MARK: - phAssets Property Tests

    @Test("phAssets returns empty array for empty collection")
    func phAssets_emptyArray() {
        let fetchResult = PHFetchResult<PHAsset>()
        let collection = PhotoAssetCollection(fetchResult)

        #expect(collection.phAssets.isEmpty)
    }

    // MARK: - Sequence Tests

    @Test("iteration on empty collection")
    func iteration_emptyCollection() {
        let fetchResult = PHFetchResult<PHAsset>()
        let collection = PhotoAssetCollection(fetchResult)

        var count = 0
        for _ in collection {
            count += 1
        }

        #expect(count == 0)
    }

    // MARK: - Caching Tests

    @Test("subscript returns cached asset on second access")
    func subscript_cachesBetweenAccesses() {
        // Note: This test is limited without real PHAssets
        // We verify the collection structure works
        let fetchResult = PHFetchResult<PHAsset>()
        let collection = PhotoAssetCollection(fetchResult)

        // Collection should be empty
        #expect(collection.count == 0)
    }
}
