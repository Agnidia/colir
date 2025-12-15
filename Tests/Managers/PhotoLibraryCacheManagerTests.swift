//
//  PhotoLibraryCacheManagerTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import Photos
import Testing
@testable import colir

@Suite("PhotoLibraryCacheManager Tests")
struct PhotoLibraryCacheManagerTests {
    // MARK: - CachedImageManagerError Tests

    @Test("CachedImageManagerError has expected cases")
    func error_hasCases() {
        // Test that all error cases exist
        _ = PhotoLibraryCacheManager.CachedImageManagerError.cancelled
        _ = PhotoLibraryCacheManager.CachedImageManagerError.failed

        #expect(true)
    }

    @Test("CachedImageManagerError.error wraps error")
    func error_wrapsError() {
        let underlyingError = NSError(domain: "test", code: 1)
        let error = PhotoLibraryCacheManager.CachedImageManagerError.error(underlyingError)

        if case .error(let wrapped) = error {
            let nsError = wrapped as NSError
            #expect(nsError.domain == "test")
            #expect(nsError.code == 1)
        } else {
            Issue.record("Expected error case")
        }
    }

    @Test("CachedImageManagerError conforms to LocalizedError")
    func error_conformsToLocalizedError() {
        let error: LocalizedError = PhotoLibraryCacheManager.CachedImageManagerError.cancelled

        #expect(error is PhotoLibraryCacheManager.CachedImageManagerError)
    }

    // MARK: - Initialization Tests

    @Test("init creates manager")
    func init_createsManager() async {
        let manager = PhotoLibraryCacheManager()

        // Verify manager is created
        let count = await manager.cachedImageCount
        #expect(count == 0)
    }

    // MARK: - cachedImageCount Tests

    @Test("cachedImageCount initially zero")
    func cachedImageCount_initiallyZero() async {
        let manager = PhotoLibraryCacheManager()

        let count = await manager.cachedImageCount
        #expect(count == 0)
    }

    // MARK: - startCaching Tests

    @Test("startCaching with empty array does nothing")
    func startCaching_emptyArray() async {
        let manager = PhotoLibraryCacheManager()

        await manager.startCaching(for: [], targetSize: CGSize(width: 100, height: 100))

        let count = await manager.cachedImageCount
        #expect(count == 0)
    }

    @Test("startCaching with PhotoAssets without phAsset")
    func startCaching_assetsWithoutPhAsset() async {
        let manager = PhotoLibraryCacheManager()

        // Create PhotoAssets without actual PHAssets
        let asset1 = PhotoAsset(identifier: "test-1")
        let asset2 = PhotoAsset(identifier: "test-2")

        await manager.startCaching(for: [asset1, asset2], targetSize: CGSize(width: 100, height: 100))

        // Should not crash, but won't cache anything without real PHAssets
        let count = await manager.cachedImageCount
        #expect(count == 0)
    }

    // MARK: - stopCaching Tests

    @Test("stopCaching with empty array does nothing")
    func stopCaching_emptyArray() async {
        let manager = PhotoLibraryCacheManager()

        await manager.stopCaching(for: [], targetSize: CGSize(width: 100, height: 100))

        let count = await manager.cachedImageCount
        #expect(count == 0)
    }

    @Test("stopCaching all assets")
    func stopCaching_allAssets() async {
        let manager = PhotoLibraryCacheManager()

        await manager.stopCaching()

        let count = await manager.cachedImageCount
        #expect(count == 0)
    }

    // MARK: - requestImage Tests

    @Test("requestImage with nil phAsset returns nil request ID")
    func requestImage_nilPhAsset() async {
        let manager = PhotoLibraryCacheManager()
        let asset = PhotoAsset(identifier: "invalid-id")

        let requestID = await manager.requestImage(
            for: asset,
            targetSize: CGSize(width: 100, height: 100)
        ) { _ in
            // Completion handler - not testing the result here
        }

        // Request ID should be nil for invalid asset
        #expect(requestID == nil)
    }

    // MARK: - cancelImageRequest Tests

    @Test("cancelImageRequest with request ID")
    func cancelImageRequest_withRequestID() async {
        let manager = PhotoLibraryCacheManager()

        // Cancel a dummy request ID
        await manager.cancelImageRequest(for: 12_345)

        // Should not crash
        #expect(true)
    }

    // MARK: - Actor Isolation Tests

    @Test("manager is properly isolated as actor")
    func actorIsolation() async {
        let manager = PhotoLibraryCacheManager()

        // Multiple concurrent accesses should be safe
        async let count1 = manager.cachedImageCount
        async let count2 = manager.cachedImageCount
        async let count3 = manager.cachedImageCount

        let counts = await [count1, count2, count3]

        #expect(counts.allSatisfy { $0 == 0 })
    }

    @Test("concurrent operations are safe")
    func concurrentOperations() async {
        let manager = PhotoLibraryCacheManager()
        let targetSize = CGSize(width: 100, height: 100)

        // Perform multiple operations concurrently
        await withTaskGroup(of: Void.self) { group in
            for _ in 0 ..< 10 {
                group.addTask {
                    await manager.startCaching(for: [], targetSize: targetSize)
                }
                group.addTask {
                    await manager.stopCaching(for: [], targetSize: targetSize)
                }
                group.addTask {
                    _ = await manager.cachedImageCount
                }
            }
        }

        // Should complete without issues
        let count = await manager.cachedImageCount
        #expect(count >= 0)
    }

    // MARK: - ImageResult TypeAlias Tests

    @Test("ImageResult tuple structure")
    func imageResult_tupleStructure() {
        // Test the ImageResult typealias structure
        let result: PhotoLibraryCacheManager.ImageResult = (image: nil, isLowerQuality: false)

        #expect(result?.image == nil)
        #expect(result?.isLowerQuality == false)
    }

    @Test("ImageResult with image")
    func imageResult_withImage() {
        let testImage = NSImage(size: NSSize(width: 100, height: 100))
        let result: PhotoLibraryCacheManager.ImageResult = (image: testImage, isLowerQuality: true)

        #expect(result?.image === testImage)
        #expect(result?.isLowerQuality == true)
    }

    @Test("ImageResult nil case")
    func imageResult_nilCase() {
        let result: PhotoLibraryCacheManager.ImageResult = nil

        #expect(result == nil)
    }
}
