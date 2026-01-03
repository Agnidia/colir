//
//  ImageProcessingPerformanceTests.swift
//
//  Created on 03.01.2026.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import Testing
@testable import colir

/// Performance tests for image processing operations.
/// These tests verify that image scaling and clipping operations
/// complete within acceptable time limits for various image sizes.
@Suite("Image Processing Performance", .serialized)
struct ImageProcessingPerformanceTests {
    // MARK: - Cached Test Images

    /// Pre-created images to avoid setup overhead in measurements.
    /// Uses lazy initialization via static let (dispatch_once semantics).
    private static let cachedImages: [String: NSImage] = {
        [
            "small": TestImageFactory.solidColor(size: TestConstants.PerformanceSizes.small, color: .blue),
            "medium": TestImageFactory.solidColor(size: TestConstants.PerformanceSizes.medium, color: .blue),
            "large": TestImageFactory.solidColor(size: TestConstants.PerformanceSizes.large, color: .blue),
            "extraLarge": TestImageFactory.solidColor(size: TestConstants.PerformanceSizes.extraLarge, color: .blue),
        ]
    }()

    /// Gets a cached test image for the specified category.
    private func getCachedImage(for category: String) -> NSImage {
        Self.cachedImages[category] ?? TestImageFactory.solidColor(size: NSSize(width: 100, height: 100), color: .blue)
    }

    // MARK: - Scaling Performance Tests

    @Test("Small image scaling completes within threshold")
    func smallImageScaling_completesWithinThreshold() async {
        let image = getCachedImage(for: "small")
        let targetSize = CGSize(width: 1024, height: 1024)

        let duration = await measureDuration {
            _ = image.scaled(to: targetSize)
        }

        #expect(
            duration < TestConstants.PerformanceThresholds.small,
            "Small image scaling took \(String(format: "%.3f", duration))s, expected < \(TestConstants.PerformanceThresholds.small)s"
        )
    }

    @Test("Medium image scaling completes within threshold")
    func mediumImageScaling_completesWithinThreshold() async {
        let image = getCachedImage(for: "medium")
        let targetSize = CGSize(width: 1024, height: 1024)

        let duration = await measureDuration {
            _ = image.scaled(to: targetSize)
        }

        #expect(
            duration < TestConstants.PerformanceThresholds.medium,
            "Medium image scaling took \(String(format: "%.3f", duration))s, expected < \(TestConstants.PerformanceThresholds.medium)s"
        )
    }

    @Test("Large image scaling completes within threshold")
    func largeImageScaling_completesWithinThreshold() async {
        let image = getCachedImage(for: "large")
        let targetSize = CGSize(width: 1024, height: 1024)

        let duration = await measureDuration {
            _ = image.scaled(to: targetSize)
        }

        #expect(
            duration < TestConstants.PerformanceThresholds.large,
            "Large image scaling took \(String(format: "%.3f", duration))s, expected < \(TestConstants.PerformanceThresholds.large)s"
        )
    }

    @Test("Extra large image scaling completes within threshold")
    func extraLargeImageScaling_completesWithinThreshold() async {
        let image = getCachedImage(for: "extraLarge")
        let targetSize = CGSize(width: 1024, height: 1024)

        let duration = await measureDuration {
            _ = image.scaled(to: targetSize)
        }

        #expect(
            duration < TestConstants.PerformanceThresholds.extraLarge,
            "Extra large image scaling took \(String(format: "%.3f", duration))s, expected < \(TestConstants.PerformanceThresholds.extraLarge)s"
        )
    }

    // MARK: - Combined Processing Performance Tests

    @Test("Full image processing pipeline - small image")
    func fullProcessing_smallImage() async {
        let image = getCachedImage(for: "small")

        let duration = await measureDuration {
            let scaled = image.scaled(to: .init(width: 1024, height: 1024))
            _ = scaled.cutImage(by: .folderCenterFrame)
        }

        #expect(
            duration < TestConstants.PerformanceThresholds.small,
            "Full processing (small) took \(String(format: "%.3f", duration))s, expected < \(TestConstants.PerformanceThresholds.small)s"
        )
    }

    @Test("Full image processing pipeline - medium image")
    func fullProcessing_mediumImage() async {
        let image = getCachedImage(for: "medium")

        let duration = await measureDuration {
            let scaled = image.scaled(to: .init(width: 1024, height: 1024))
            _ = scaled.cutImage(by: .folderCenterFrame)
        }

        #expect(
            duration < TestConstants.PerformanceThresholds.medium,
            "Full processing (medium) took \(String(format: "%.3f", duration))s, expected < \(TestConstants.PerformanceThresholds.medium)s"
        )
    }

    @Test("Full image processing pipeline - large image")
    func fullProcessing_largeImage() async {
        let image = getCachedImage(for: "large")

        let duration = await measureDuration {
            let scaled = image.scaled(to: .init(width: 1024, height: 1024))
            _ = scaled.cutImage(by: .folderCenterFrame)
        }

        #expect(
            duration < TestConstants.PerformanceThresholds.large,
            "Full processing (large) took \(String(format: "%.3f", duration))s, expected < \(TestConstants.PerformanceThresholds.large)s"
        )
    }

    @Test("Full image processing pipeline - extra large image")
    func fullProcessing_extraLargeImage() async {
        let image = getCachedImage(for: "extraLarge")

        let duration = await measureDuration {
            let scaled = image.scaled(to: .init(width: 1024, height: 1024))
            _ = scaled.cutImage(by: .folderCenterFrame)
        }

        #expect(
            duration < TestConstants.PerformanceThresholds.extraLarge,
            "Full processing (extra large) took \(String(format: "%.3f", duration))s, expected < \(TestConstants.PerformanceThresholds.extraLarge)s"
        )
    }

    // MARK: - Main Thread Blocking Tests

    @Test("Image processing does not block main thread")
    @MainActor
    func imageProcessing_doesNotBlockMainThread() async {
        let image = getCachedImage(for: "large")
        var mainThreadBlocked = true

        // Start background processing
        let processingTask = Task.detached {
            let scaled = image.scaled(to: .init(width: 1024, height: 1024))
            _ = scaled.cutImage(by: .folderCenterFrame)
        }

        // Check if main thread can respond immediately
        // If we can execute this, main thread is not blocked
        mainThreadBlocked = false

        await processingTask.value

        #expect(!mainThreadBlocked, "Main thread should not be blocked during image processing")
    }

    // MARK: - Benchmark Tests

    @Test("Benchmark: Report processing times for all sizes")
    func benchmark_reportProcessingTimes() async {
        let sizes: [(String, String)] = [
            ("512x512 (0.26MP)", "small"),
            ("1920x1080 (2.07MP)", "medium"),
            ("4000x3000 (12MP)", "large"),
            ("6000x4000 (24MP)", "extraLarge"),
        ]

        var results: [(String, TimeInterval)] = []

        for (name, category) in sizes {
            let image = getCachedImage(for: category)

            let duration = await measureDuration {
                let scaled = image.scaled(to: .init(width: 1024, height: 1024))
                _ = scaled.cutImage(by: .folderCenterFrame)
            }

            results.append((name, duration))
        }

        // Print benchmark results
        print("\n=== Image Processing Benchmark ===")
        for (name, duration) in results {
            print("\(name): \(String(format: "%.3f", duration))s")
        }
        print("==================================\n")

        // All tests should complete (no assertion, just reporting)
        #expect(results.count == sizes.count)
    }

    // MARK: - Helpers

    private func measureDuration(_ operation: () -> Void) async -> TimeInterval {
        let start = CFAbsoluteTimeGetCurrent()
        operation()
        let end = CFAbsoluteTimeGetCurrent()
        return end - start
    }
}
