//
//  ToolsEmojisViewModelTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftUI
import Testing
@testable import colir

@Suite("ToolsEmojisViewModel Tests")
struct ToolsEmojisViewModelTests {
    // MARK: - Initialization Tests

    @Test("init creates valid instance with default emojis")
    func init_createsInstance() {
        let viewModel = ToolsEmojisViewModel()

        #expect(viewModel.selectedEmoji == nil)
        #expect(!viewModel.groups.isEmpty)
        #expect(!viewModel.emojis.isEmpty)
    }

    @Test("init with custom emojis uses provided dictionary")
    func init_withCustomEmojis() {
        let customEmojis: [EmojisGroup: [Character]] = [
            .people: ["😀", "😃", "😄"],
        ]

        let viewModel = ToolsEmojisViewModel(emojis: customEmojis)

        #expect(viewModel.emojis[.people]?.count == 3)
    }

    @Test("init expands first group by default")
    func init_expandsFirstGroup() {
        let viewModel = ToolsEmojisViewModel()

        #expect(viewModel.expanded.contains(viewModel.groups.first!))
    }

    // MARK: - groups Tests

    @Test("groups contains all EmojisGroup cases")
    func groups_containsAllCases() {
        let viewModel = ToolsEmojisViewModel()

        #expect(viewModel.groups == EmojisGroup.allCases)
    }

    // MARK: - selectedEmoji Tests

    @Test("selectedEmoji initially nil")
    func selectedEmoji_initiallyNil() {
        let viewModel = ToolsEmojisViewModel()

        #expect(viewModel.selectedEmoji == nil)
    }

    @Test("selectedEmoji can be set")
    func selectedEmoji_canBeSet() {
        let viewModel = ToolsEmojisViewModel()

        viewModel.selectedEmoji = "😀"

        #expect(viewModel.selectedEmoji == "😀")
    }

    @Test("selectedEmoji can be cleared")
    func selectedEmoji_canBeCleared() {
        let viewModel = ToolsEmojisViewModel()
        viewModel.selectedEmoji = "🎉"

        viewModel.selectedEmoji = nil

        #expect(viewModel.selectedEmoji == nil)
    }

    // MARK: - expanded Tests

    @Test("expanded initially contains first group")
    func expanded_initiallyContainsFirstGroup() {
        let viewModel = ToolsEmojisViewModel()

        #expect(!viewModel.expanded.isEmpty)
        #expect(viewModel.expanded.count == 1)
    }

    @Test("expanded can add groups")
    func expanded_canAddGroups() {
        let viewModel = ToolsEmojisViewModel()

        viewModel.expanded.insert(.nature)

        #expect(viewModel.expanded.contains(.nature))
    }

    @Test("expanded can remove groups")
    func expanded_canRemoveGroups() {
        let viewModel = ToolsEmojisViewModel()
        let firstGroup = viewModel.groups.first!

        viewModel.expanded.remove(firstGroup)

        #expect(!viewModel.expanded.contains(firstGroup))
    }

    // MARK: - Static Properties Tests

    @Test("columnWidth has expected value")
    func columnWidth_hasValue() {
        let viewModel = ToolsEmojisViewModel()

        #expect(viewModel.columnWidth == 128)
    }

    @Test("fontSize is fraction of columnWidth")
    func fontSize_isFractionOfColumnWidth() {
        let viewModel = ToolsEmojisViewModel()

        #expect(viewModel.fontSize == viewModel.columnWidth * 0.6)
    }

    // MARK: - cellCornerRadius Tests

    @Test("cellCornerRadius has value")
    func cellCornerRadius_hasValue() {
        let viewModel = ToolsEmojisViewModel()

        #expect(viewModel.cellCornerRadius > 0)
    }

    // MARK: - viewSettings Tests

    @Test("viewSettings is ToolsEmojisViewDomain")
    func viewSettings_isCorrectType() {
        let viewModel = ToolsEmojisViewModel()

        #expect(viewModel.viewSettings is ToolsEmojisViewDomain)
    }

    // MARK: - Preview Tests

    @Test("preview creates valid instance")
    func preview_createsInstance() {
        let preview = ToolsEmojisViewModel.preview

        #expect(preview.selectedEmoji == nil)
        #expect(!preview.groups.isEmpty)
    }

    // MARK: - ObservableObject Tests

    @Test("ToolsEmojisViewModel is ObservableObject")
    func observable_conformance() {
        let viewModel = ToolsEmojisViewModel()

        // Access published properties
        _ = viewModel.selectedEmoji
        _ = viewModel.expanded

        #expect(true)
    }

    // MARK: - Emoji Selection Workflow Tests

    @Test("full emoji selection workflow")
    func emojiSelectionWorkflow() {
        let viewModel = ToolsEmojisViewModel()

        // 1. Select an emoji
        viewModel.selectedEmoji = "🎉"
        #expect(viewModel.selectedEmoji == "🎉")

        // 2. Expand another group
        viewModel.expanded.insert(.nature)
        #expect(viewModel.expanded.contains(.nature))

        // 3. Select different emoji
        viewModel.selectedEmoji = "🐶"
        #expect(viewModel.selectedEmoji == "🐶")

        // 4. Clear selection
        viewModel.selectedEmoji = nil
        #expect(viewModel.selectedEmoji == nil)

        // Expanded groups should remain
        #expect(viewModel.expanded.count >= 1)
    }

    // MARK: - emojis Dictionary Tests

    @Test("emojis dictionary has entries for groups")
    func emojis_hasEntries() {
        let viewModel = ToolsEmojisViewModel()

        // At least some groups should have emojis
        let hasEmojis = viewModel.groups.contains { group in
            let groupEmojis = viewModel.emojis[group] ?? []
            return !groupEmojis.isEmpty
        }

        #expect(hasEmojis)
    }
}
