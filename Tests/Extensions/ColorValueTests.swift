//
//  ColorValueTests.swift
//  colirTests
//
//  Created by Claude Code on 2025-12-15.
//  Copyright (c) 2025 IGR Software. All rights reserved.
//

@testable import colir
import SwiftUI
import Testing

@Suite("Color Value Extension")
struct ColorValueTests {
    // MARK: - white0 Tests

    @Test("white0 returns white with very low opacity")
    func white0_returnsWhiteWithLowOpacity() {
        let color = Color.white0

        // Verify the color is created (we can't easily test the exact opacity in SwiftUI Color)
        #expect(color != Color.white) // Should be different due to opacity
        #expect(color != Color.clear) // Should not be fully transparent
    }

    // MARK: - black0 Tests

    @Test("black0 returns black with very low opacity")
    func black0_returnsBlackWithLowOpacity() {
        let color = Color.black0

        // Verify the color is created (we can't easily test the exact opacity in SwiftUI Color)
        #expect(color != Color.black) // Should be different due to opacity
        #expect(color != Color.clear) // Should not be fully transparent
    }

    // MARK: - Consistency Tests

    @Test("white0 and black0 are different")
    func white0_black0_different() {
        let white0 = Color.white0
        let black0 = Color.black0

        // They should be different colors
        #expect(white0 != black0)
    }

    @Test("white0 returns same value on multiple calls")
    func white0_consistent() {
        let first = Color.white0
        let second = Color.white0

        #expect(first == second)
    }

    @Test("black0 returns same value on multiple calls")
    func black0_consistent() {
        let first = Color.black0
        let second = Color.black0

        #expect(first == second)
    }
}
