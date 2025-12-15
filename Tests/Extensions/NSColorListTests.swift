//
//  NSColorListTests.swift
//  colirTests
//
//  Created by Claude Code on 2025-12-15.
//  Copyright (c) 2025 IGR Software. All rights reserved.
//

import AppKit
@testable import colir
import Testing

@Suite("NSColor List Extension")
struct NSColorListTests {
    // MARK: - Individual Color Tests

    @Test("slate colors are defined")
    func slateColors_defined() {
        #expect(NSColor.slate50 != nil)
        #expect(NSColor.slate500 != nil)
        #expect(NSColor.slate950 != nil)
    }

    @Test("gray colors are defined")
    func grayColors_defined() {
        #expect(NSColor.gray50 != nil)
        #expect(NSColor.gray500 != nil)
        #expect(NSColor.gray950 != nil)
    }

    @Test("red colors are defined")
    func redColors_defined() {
        #expect(NSColor.red50 != nil)
        #expect(NSColor.red500 != nil)
        #expect(NSColor.red950 != nil)
    }

    @Test("blue colors are defined")
    func blueColors_defined() {
        #expect(NSColor.blue50 != nil)
        #expect(NSColor.blue500 != nil)
        #expect(NSColor.blue950 != nil)
    }

    @Test("green colors are defined")
    func greenColors_defined() {
        #expect(NSColor.green50 != nil)
        #expect(NSColor.green500 != nil)
        #expect(NSColor.green950 != nil)
    }

    // MARK: - Color Array Tests

    @Test("slate array has 11 colors")
    func slateArray_has11Colors() {
        #expect(NSColor.slate.count == 11)
    }

    @Test("all color type arrays have 11 colors")
    func colorTypeArrays_have11Colors() {
        let colorArrays: [[NSColor]] = [
            NSColor.slate, NSColor.gray, NSColor.zinc, NSColor.neutral, NSColor.stone,
            NSColor.red, NSColor.orange, NSColor.amber, NSColor.yellow, NSColor.lime,
            NSColor.green, NSColor.emerald, NSColor.teal, NSColor.cyan, NSColor.sky,
            NSColor.blue, NSColor.indigo, NSColor.violet, NSColor.purple, NSColor.fuchsia,
            NSColor.pink, NSColor.rose,
        ]

        for array in colorArrays {
            #expect(array.count == 11)
        }
    }

    // MARK: - Groups By Type Tests

    @Test("groupsByType has all color families")
    func groupsByType_hasAllFamilies() {
        let expectedFamilies = [
            "slate", "gray", "zinc", "neutral", "stone",
            "red", "orange", "amber", "yellow", "lime",
            "green", "emerald", "teal", "cyan", "sky",
            "blue", "indigo", "violet", "purple", "fuchsia",
            "pink", "rose",
        ]

        for family in expectedFamilies {
            #expect(NSColor.groupsByType[family] != nil, "Missing family: \(family)")
        }
    }

    @Test("groupsByType has 22 families")
    func groupsByType_has22Families() {
        #expect(NSColor.groupsByType.count == 22)
    }

    // MARK: - Groups By Depth Tests

    @Test("groupsByDepth has all depth levels")
    func groupsByDepth_hasAllLevels() {
        let expectedDepths: [UInt16] = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950]

        for depth in expectedDepths {
            #expect(NSColor.groupsByDepth[depth] != nil, "Missing depth: \(depth)")
        }
    }

    @Test("depth50 has 22 colors")
    func depth50_has22Colors() {
        #expect(NSColor.depth50.count == 22)
    }

    @Test("all depth arrays have 22 colors")
    func depthArrays_have22Colors() {
        let depthArrays = [
            NSColor.depth50, NSColor.depth100, NSColor.depth200, NSColor.depth300,
            NSColor.depth400, NSColor.depth500, NSColor.depth600, NSColor.depth700,
            NSColor.depth800, NSColor.depth900, NSColor.depth950,
        ]

        for array in depthArrays {
            #expect(array.count == 22)
        }
    }

    // MARK: - All Colors Tests

    @Test("all contains all colors")
    func all_containsAllColors() {
        // 22 families × 11 shades = 242 colors
        #expect(NSColor.all.count == 242)
    }

    // MARK: - ColorGroup Tests

    @Test("ColorGroup initializes correctly")
    func colorGroup_initializes() {
        let colors: [NSColor] = NSColor.red
        let group = NSColor.ColorGroup(id: "red", name: "Red", colors: colors)

        #expect(group.id == "red")
        #expect(group.name == "Red")
        #expect(group.colors.count == 11)
        #expect(group.primaryColor == colors[5]) // 500 shade at index 5
    }

    @Test("ColorGroup equality")
    func colorGroup_equality() {
        let group1 = NSColor.ColorGroup(id: "red", name: "Red", colors: NSColor.red)
        let group2 = NSColor.ColorGroup(id: "red", name: "Red", colors: NSColor.red)
        let group3 = NSColor.ColorGroup(id: "blue", name: "Blue", colors: NSColor.blue)

        #expect(group1 == group2)
        #expect(group1 != group3)
    }

    @Test("ColorGroup hashable")
    func colorGroup_hashable() {
        let group1 = NSColor.ColorGroup(id: "red", name: "Red", colors: NSColor.red)
        let group2 = NSColor.ColorGroup(id: "red", name: "Red", colors: NSColor.red)

        var set = Set<NSColor.ColorGroup>()
        set.insert(group1)
        set.insert(group2)

        #expect(set.count == 1) // Same id, should only have one entry
    }

    @Test("ColorGroup primaryColor uses 500 shade")
    func colorGroup_primaryColor() {
        let group = NSColor.ColorGroup(id: "blue", name: "Blue", colors: NSColor.blue)

        #expect(group.primaryColor == NSColor.blue500)
    }

    @Test("ColorGroup with short array uses first color")
    func colorGroup_shortArray_usesFirstColor() {
        let shortColors = [NSColor.red50, NSColor.red100]
        let group = NSColor.ColorGroup(id: "test", name: "Test", colors: shortColors)

        // Index 5 doesn't exist, so should use first color
        #expect(group.primaryColor == shortColors.first)
    }

    // MARK: - colorGroupsOrdered Tests

    @Test("colorGroupsOrdered has 22 groups")
    func colorGroupsOrdered_has22Groups() {
        #expect(NSColor.colorGroupsOrdered.count == 22)
    }

    @Test("colorGroupsOrdered starts with warm colors")
    func colorGroupsOrdered_startsWithWarm() {
        let first = NSColor.colorGroupsOrdered.first
        #expect(first?.id == "red")
    }

    @Test("colorGroupsOrdered ends with grays")
    func colorGroupsOrdered_endsWithGrays() {
        let last = NSColor.colorGroupsOrdered.last
        #expect(last?.id == "stone")
    }

    @Test("colorGroupsOrdered has unique ids")
    func colorGroupsOrdered_uniqueIds() {
        let ids = NSColor.colorGroupsOrdered.map(\.id)
        let uniqueIds = Set(ids)

        #expect(ids.count == uniqueIds.count)
    }

    // MARK: - Hex Color Conversion Tests

    @Test("red500 is correct hex value")
    func red500_correctHex() {
        // #ef4444
        let red500 = NSColor.red500

        // Get RGB components
        guard let rgb = red500.usingColorSpace(.sRGB) else {
            Issue.record("Could not convert to sRGB")
            return
        }

        // ef = 239, 44 = 68, 44 = 68
        let expectedRed = CGFloat(0xEF) / 255.0
        let expectedGreen = CGFloat(0x44) / 255.0
        let expectedBlue = CGFloat(0x44) / 255.0

        // Use 0.1 tolerance for color space conversion differences
        #expect(abs(rgb.redComponent - expectedRed) < 0.1)
        #expect(abs(rgb.greenComponent - expectedGreen) < 0.1)
        #expect(abs(rgb.blueComponent - expectedBlue) < 0.1)
    }

    @Test("blue500 is correct hex value")
    func blue500_correctHex() {
        // #3b82f6
        let blue500 = NSColor.blue500

        guard let rgb = blue500.usingColorSpace(.sRGB) else {
            Issue.record("Could not convert to sRGB")
            return
        }

        // 3b = 59, 82 = 130, f6 = 246
        let expectedRed = CGFloat(0x3B) / 255.0
        let expectedGreen = CGFloat(0x82) / 255.0
        let expectedBlue = CGFloat(0xF6) / 255.0

        // Use 0.1 tolerance for color space conversion differences
        #expect(abs(rgb.redComponent - expectedRed) < 0.1)
        #expect(abs(rgb.greenComponent - expectedGreen) < 0.1)
        #expect(abs(rgb.blueComponent - expectedBlue) < 0.1)
    }

    // MARK: - Color Progression Tests

    @Test("colors progress from light to dark")
    func colorsProgression_lightToDark() {
        let redColors: [NSColor] = NSColor.red

        // First color (50) should be lighter than last (950)
        guard let first = redColors.first?.usingColorSpace(NSColorSpace.sRGB),
              let last = redColors.last?.usingColorSpace(NSColorSpace.sRGB)
        else {
            Issue.record("Could not convert colors")
            return
        }

        // Light colors have higher brightness
        let firstBrightness = (first.redComponent + first.greenComponent + first.blueComponent) / 3
        let lastBrightness = (last.redComponent + last.greenComponent + last.blueComponent) / 3

        #expect(firstBrightness > lastBrightness)
    }
}
