//
//  TestConstants.swift
//
//  Created on 03.01.2026.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import Foundation

/// Shared constants for image tests.
enum TestConstants {
    /// Standard icon sizes used across tests.
    static let iconSizes: [NSSize] = [
        NSSize(width: 16, height: 16),
        NSSize(width: 32, height: 32),
        NSSize(width: 64, height: 64),
        NSSize(width: 128, height: 128),
        NSSize(width: 256, height: 256),
    ]

    /// Extended icon sizes (includes 512).
    static let extendedIconSizes: [NSSize] = iconSizes + [
        NSSize(width: 512, height: 512),
    ]

    /// Alpha test values (boundary + common values).
    static let alphaValues: [UInt8] = [0, 1, 25, 50, 100, 128, 175, 200, 254, 255]

    /// Standard test colors.
    static let testColors: [NSColor] = [
        .red, .green, .blue, .yellow, .purple, .cyan, .magenta, .orange,
    ]

    /// Performance test image sizes.
    enum PerformanceSizes {
        /// Small: 512x512 (0.26 MP)
        static let small = NSSize(width: 512, height: 512)
        /// Medium: 1920x1080 (2.07 MP)
        static let medium = NSSize(width: 1920, height: 1080)
        /// Large: 4000x3000 (12 MP)
        static let large = NSSize(width: 4000, height: 3000)
        /// Extra Large: 6000x4000 (24 MP)
        static let extraLarge = NSSize(width: 6000, height: 4000)
    }

    /// Performance thresholds in seconds.
    enum PerformanceThresholds {
        static let small: TimeInterval = 0.1
        static let medium: TimeInterval = 0.3
        static let large: TimeInterval = 0.8
        static let extraLarge: TimeInterval = 2.0
    }
}
