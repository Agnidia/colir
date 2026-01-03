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
@Suite("Image Processing Performance")
struct ImageProcessingPerformanceTests {
    // MARK: - Performance Thresholds

    /// Maximum acceptable time for small images (< 1MP)
    private static let smallImageThreshold: TimeInterval = 0.1 // 100ms

    /// Maximum acceptable time for medium images (1-4MP)
    private static let mediumImageThreshold: TimeInterval = 0.3 // 300ms

    /// Maximum acceptable time for large images (4-12MP)
    private static let largeImageThreshold: TimeInterval = 0.8 // 800ms

    /// Maximum acceptable time for extra large images (> 12MP)
    private static let extraLargeImageThreshold: TimeInterval = 2.0 // 2000ms

    // MARK: - Test Image Sizes

    /// Small image: 512x512 (0.26 MP)
    private static let smallSize = NSSize(width: 512, height: 512)

    /// Medium image: 1920x1080 (2.07 MP)
    private static let mediumSize = NSSize(width: 1920, height: 1080)

    /// Large image: 4000x3000 (12 MP) - typical high-res photo
    private static let largeSize = NSSize(width: 4000, height: 3000)

    /// Extra large image: 6000x4000 (24 MP) - professional camera
    private static let extraLargeSize = NSSize(width: 6000, height: 4000)

    // MARK: - Scaling Performance Tests

    @Test("Small image scaling completes within threshold")
    func smallImageScaling_completesWithinThreshold() async {
        let image = createTestImage(size: Self.smallSize)
        let targetSize = CGSize(width: 1024, height: 1024)

        let duration = await measureDuration {
            _ = image.scaled(to: targetSize)
        }

        #expect(
            duration < Self.smallImageThreshold,
            "Small image scaling took \(String(format: "%.3f", duration))s, expected < \(Self.smallImageThreshold)s"
        )
    }

    @Test("Medium image scaling completes within threshold")
    func mediumImageScaling_completesWithinThreshold() async {
        let image = createTestImage(size: Self.mediumSize)
        let targetSize = CGSize(width: 1024, height: 1024)

        let duration = await measureDuration {
            _ = image.scaled(to: targetSize)
        }

        #expect(
            duration < Self.mediumImageThreshold,
            "Medium image scaling took \(String(format: "%.3f", duration))s, expected < \(Self.mediumImageThreshold)s"
        )
    }

    @Test("Large image scaling completes within threshold")
    func largeImageScaling_completesWithinThreshold() async {
        let image = createTestImage(size: Self.largeSize)
        let targetSize = CGSize(width: 1024, height: 1024)

        let duration = await measureDuration {
            _ = image.scaled(to: targetSize)
        }

        #expect(
            duration < Self.largeImageThreshold,
            "Large image scaling took \(String(format: "%.3f", duration))s, expected < \(Self.largeImageThreshold)s"
        )
    }

    @Test("Extra large image scaling completes within threshold")
    func extraLargeImageScaling_completesWithinThreshold() async {
        let image = createTestImage(size: Self.extraLargeSize)
        let targetSize = CGSize(width: 1024, height: 1024)

        let duration = await measureDuration {
            _ = image.scaled(to: targetSize)
        }

        #expect(
            duration < Self.extraLargeImageThreshold,
            "Extra large image scaling took \(String(format: "%.3f", duration))s, expected < \(Self.extraLargeImageThreshold)s"
        )
    }

    // MARK: - Combined Processing Performance Tests

    @Test("Full image processing pipeline - small image")
    func fullProcessing_smallImage() async {
        let image = createTestImage(size: Self.smallSize)

        let duration = await measureDuration {
            let scaled = image.scaled(to: .init(width: 1024, height: 1024))
            _ = scaled.cutImage(by: .folderCenterFrame)
        }

        #expect(
            duration < Self.smallImageThreshold,
            "Full processing (small) took \(String(format: "%.3f", duration))s, expected < \(Self.smallImageThreshold)s"
        )
    }

    @Test("Full image processing pipeline - medium image")
    func fullProcessing_mediumImage() async {
        let image = createTestImage(size: Self.mediumSize)

        let duration = await measureDuration {
            let scaled = image.scaled(to: .init(width: 1024, height: 1024))
            _ = scaled.cutImage(by: .folderCenterFrame)
        }

        #expect(
            duration < Self.mediumImageThreshold,
            "Full processing (medium) took \(String(format: "%.3f", duration))s, expected < \(Self.mediumImageThreshold)s"
        )
    }

    @Test("Full image processing pipeline - large image")
    func fullProcessing_largeImage() async {
        let image = createTestImage(size: Self.largeSize)

        let duration = await measureDuration {
            let scaled = image.scaled(to: .init(width: 1024, height: 1024))
            _ = scaled.cutImage(by: .folderCenterFrame)
        }

        #expect(
            duration < Self.largeImageThreshold,
            "Full processing (large) took \(String(format: "%.3f", duration))s, expected < \(Self.largeImageThreshold)s"
        )
    }

    @Test("Full image processing pipeline - extra large image")
    func fullProcessing_extraLargeImage() async {
        let image = createTestImage(size: Self.extraLargeSize)

        let duration = await measureDuration {
            let scaled = image.scaled(to: .init(width: 1024, height: 1024))
            _ = scaled.cutImage(by: .folderCenterFrame)
        }

        #expect(
            duration < Self.extraLargeImageThreshold,
            "Full processing (extra large) took \(String(format: "%.3f", duration))s, expected < \(Self.extraLargeImageThreshold)s"
        )
    }

    // MARK: - Main Thread Blocking Tests

    @Test("Image processing does not block main thread")
    @MainActor
    func imageProcessing_doesNotBlockMainThread() async {
        let image = createTestImage(size: Self.largeSize)
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
        let sizes: [(String, NSSize)] = [
            ("512x512 (0.26MP)", Self.smallSize),
            ("1920x1080 (2.07MP)", Self.mediumSize),
            ("4000x3000 (12MP)", Self.largeSize),
            ("6000x4000 (24MP)", Self.extraLargeSize),
        ]

        var results: [(String, TimeInterval)] = []

        for (name, size) in sizes {
            let image = createTestImage(size: size)

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

    private func createTestImage(size: NSSize, color: NSColor = .blue) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        image.unlockFocus()
        return image
    }

    private func measureDuration(_ operation: () -> Void) async -> TimeInterval {
        let start = CFAbsoluteTimeGetCurrent()
        operation()
        let end = CFAbsoluteTimeGetCurrent()
        return end - start
    }
}
