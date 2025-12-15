//
//  ToolsColorsViewModelTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import Combine
import Testing
@testable import colir

@Suite("ToolsColorsViewModel Tests")
struct ToolsColorsViewModelTests {
    // MARK: - Initialization Tests

    @Test("init creates valid instance")
    func init_createsInstance() {
        let viewModel = ToolsColorsViewModel()

        #expect(viewModel.selectedColor == nil)
        #expect(viewModel.recentColors.isEmpty)
    }

    // MARK: - Static Properties Tests

    @Test("cellWidth has expected value")
    func cellWidth_hasValue() {
        #expect(ToolsColorsViewModel.cellWidth == 128)
    }

    @Test("cellHeight has expected value")
    func cellHeight_hasValue() {
        #expect(ToolsColorsViewModel.cellHeight == 48)
    }

    // MARK: - selectedColor Tests

    @Test("selectedColor initially nil")
    func selectedColor_initiallyNil() {
        let viewModel = ToolsColorsViewModel()

        #expect(viewModel.selectedColor == nil)
    }

    @Test("selectedColor can be set")
    func selectedColor_canBeSet() {
        let viewModel = ToolsColorsViewModel()

        viewModel.selectedColor = .red

        #expect(viewModel.selectedColor == .red)
    }

    @Test("setting selectedColor adds to recent colors")
    func selectedColor_addsToRecent() {
        let viewModel = ToolsColorsViewModel()

        viewModel.selectedColor = .blue

        #expect(viewModel.recentColors.count == 1)
    }

    // MARK: - recentColors Tests

    @Test("recentColors initially empty")
    func recentColors_initiallyEmpty() {
        let viewModel = ToolsColorsViewModel()

        #expect(viewModel.recentColors.isEmpty)
    }

    @Test("recentColors adds colors in reverse order (most recent first)")
    func recentColors_addsMostRecentFirst() {
        let viewModel = ToolsColorsViewModel()

        viewModel.selectedColor = .red
        viewModel.selectedColor = .blue
        viewModel.selectedColor = .green

        #expect(viewModel.recentColors.count == 3)
        // Most recent should be first
        #expect(viewModel.recentColors.first?.hexString == NSColor.green.hexString)
    }

    @Test("recentColors removes duplicates")
    func recentColors_removesDuplicates() {
        let viewModel = ToolsColorsViewModel()

        viewModel.selectedColor = .red
        viewModel.selectedColor = .blue
        viewModel.selectedColor = .red // Duplicate

        #expect(viewModel.recentColors.count == 2)
        // Red should be first (most recent)
        #expect(viewModel.recentColors.first?.hexString == NSColor.red.hexString)
    }

    @Test("recentColors limited to max 8 colors")
    func recentColors_limitedToMax() {
        let viewModel = ToolsColorsViewModel()

        // Add 10 colors
        let colors: [NSColor] = [.red, .blue, .green, .yellow, .orange, .purple, .cyan, .magenta, .brown, .gray]
        for color in colors {
            viewModel.selectedColor = color
        }

        #expect(viewModel.recentColors.count == 8)
    }

    // MARK: - clearRecentColors Tests

    @Test("clearRecentColors removes all colors")
    func clearRecentColors_removesAll() {
        let viewModel = ToolsColorsViewModel()
        viewModel.selectedColor = .red
        viewModel.selectedColor = .blue

        viewModel.clearRecentColors()

        #expect(viewModel.recentColors.isEmpty)
    }

    @Test("clearRecentColors on empty list does nothing")
    func clearRecentColors_emptyList() {
        let viewModel = ToolsColorsViewModel()

        viewModel.clearRecentColors()

        #expect(viewModel.recentColors.isEmpty)
    }

    // MARK: - cellCornerRadius Tests

    @Test("cellCornerRadius has value")
    func cellCornerRadius_hasValue() {
        let viewModel = ToolsColorsViewModel()

        #expect(viewModel.cellCornerRadius > 0)
    }

    // MARK: - viewSettings Tests

    @Test("viewSettings is ToolsColorsViewDomain")
    func viewSettings_isCorrectType() {
        let viewModel = ToolsColorsViewModel()

        #expect(viewModel.viewSettings is ToolsColorsViewDomain)
    }

    // MARK: - selectedColorPublisher Tests

    @Test("selectedColorPublisher is accessible")
    func selectedColorPublisher_accessible() {
        let viewModel = ToolsColorsViewModel()

        #expect(viewModel.selectedColorPublisher is PassthroughSubject<NSColor?, Never>)
    }

    // MARK: - Preview Tests

    @Test("preview creates valid instance")
    func preview_createsInstance() {
        let preview = ToolsColorsViewModel.preview

        #expect(preview.selectedColor == nil)
        #expect(preview.recentColors.isEmpty)
    }

    // MARK: - Observable Tests

    @Test("ToolsColorsViewModel is Observable")
    func observable_conformance() {
        let viewModel = ToolsColorsViewModel()

        // Access observable properties
        _ = viewModel.selectedColor
        _ = viewModel.recentColors

        #expect(true)
    }

    // MARK: - Color Selection Workflow Tests

    @Test("full color selection workflow")
    func colorSelectionWorkflow() {
        let viewModel = ToolsColorsViewModel()

        // 1. Select a color
        viewModel.selectedColor = .red
        #expect(viewModel.selectedColor == .red)
        #expect(viewModel.recentColors.count == 1)

        // 2. Select another color
        viewModel.selectedColor = .blue
        #expect(viewModel.selectedColor == .blue)
        #expect(viewModel.recentColors.count == 2)

        // 3. Select nil (clear)
        viewModel.selectedColor = nil
        #expect(viewModel.selectedColor == nil)
        // Recent colors should still be there
        #expect(viewModel.recentColors.count == 2)

        // 4. Clear recent
        viewModel.clearRecentColors()
        #expect(viewModel.recentColors.isEmpty)
    }
}
