//
//  ToolbarViewModelTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("ToolbarViewModel Tests")
struct ToolbarViewModelTests {
    // MARK: - Initialization Tests

    @Test("init creates valid instance")
    func init_createsInstance() {
        var actionCalled = false
        let undoManager = UndoManager()

        let viewModel = ToolbarViewModel(undoManager: undoManager) { _ in
            actionCalled = true
        }

        #expect(viewModel.undoManager === undoManager)
        #expect(actionCalled == false)
    }

    // MARK: - perform Tests

    @Test("perform calls action callback with correct action")
    func perform_callsCallback() {
        var receivedAction: ToolbarView.ToolbarViewDomain.Action?
        let viewModel = ToolbarViewModel(undoManager: UndoManager()) { action in
            receivedAction = action
        }

        viewModel.perform(.colors)

        #expect(receivedAction == .colors)
    }

    @Test("perform with undo action")
    func perform_undoAction() {
        var receivedAction: ToolbarView.ToolbarViewDomain.Action?
        let viewModel = ToolbarViewModel(undoManager: UndoManager()) { action in
            receivedAction = action
        }

        viewModel.perform(.undo)

        #expect(receivedAction == .undo)
    }

    @Test("perform with redo action")
    func perform_redoAction() {
        var receivedAction: ToolbarView.ToolbarViewDomain.Action?
        let viewModel = ToolbarViewModel(undoManager: UndoManager()) { action in
            receivedAction = action
        }

        viewModel.perform(.redo)

        #expect(receivedAction == .redo)
    }

    @Test("perform with photos action")
    func perform_photosAction() {
        var receivedAction: ToolbarView.ToolbarViewDomain.Action?
        let viewModel = ToolbarViewModel(undoManager: UndoManager()) { action in
            receivedAction = action
        }

        viewModel.perform(.photos)

        #expect(receivedAction == .photos)
    }

    @Test("perform with pictures action")
    func perform_picturesAction() {
        var receivedAction: ToolbarView.ToolbarViewDomain.Action?
        let viewModel = ToolbarViewModel(undoManager: UndoManager()) { action in
            receivedAction = action
        }

        viewModel.perform(.pictures)

        #expect(receivedAction == .pictures)
    }

    @Test("perform with emojis action")
    func perform_emojisAction() {
        var receivedAction: ToolbarView.ToolbarViewDomain.Action?
        let viewModel = ToolbarViewModel(undoManager: UndoManager()) { action in
            receivedAction = action
        }

        viewModel.perform(.emojis)

        #expect(receivedAction == .emojis)
    }

    @Test("perform with tips action")
    func perform_tipsAction() {
        var receivedAction: ToolbarView.ToolbarViewDomain.Action?
        let viewModel = ToolbarViewModel(undoManager: UndoManager()) { action in
            receivedAction = action
        }

        viewModel.perform(.tips)

        #expect(receivedAction == .tips)
    }

    // MARK: - undoManager Tests

    @Test("undoManager is accessible")
    func undoManager_isAccessible() {
        let undoManager = UndoManager()
        let viewModel = ToolbarViewModel(undoManager: undoManager) { _ in }

        #expect(viewModel.undoManager === undoManager)
    }

    // MARK: - hasTipped Tests

    @Test("init with hasTipped false by default")
    func init_hasTippedDefaultFalse() {
        let viewModel = ToolbarViewModel(undoManager: UndoManager()) { _ in }

        #expect(viewModel.hasTipped == false)
    }

    @Test("init with hasTipped true")
    func init_hasTippedTrue() {
        let viewModel = ToolbarViewModel(undoManager: UndoManager(), hasTipped: true) { _ in }

        #expect(viewModel.hasTipped == true)
    }

    @Test("hasTipped can be modified")
    func hasTipped_canBeModified() {
        let viewModel = ToolbarViewModel(undoManager: UndoManager(), hasTipped: false) { _ in }

        #expect(viewModel.hasTipped == false)
        viewModel.hasTipped = true
        #expect(viewModel.hasTipped == true)
    }

    // MARK: - Preview Tests

    @Test("preview creates valid instance")
    @MainActor
    func preview_createsInstance() {
        let preview = ToolbarViewModel.preview

        #expect(preview.undoManager != nil)
    }

    @Test("preview has hasTipped false")
    @MainActor
    func preview_hasTippedFalse() {
        let preview = ToolbarViewModel.preview

        #expect(preview.hasTipped == false)
    }

    // MARK: - Action Callback Tests

    @Test("callback tracks multiple actions")
    func callback_tracksMultipleActions() {
        var actions: [ToolbarView.ToolbarViewDomain.Action] = []
        let viewModel = ToolbarViewModel(undoManager: UndoManager()) { action in
            actions.append(action)
        }

        viewModel.perform(.colors)
        viewModel.perform(.photos)
        viewModel.perform(.emojis)

        #expect(actions.count == 3)
        #expect(actions[0] == .colors)
        #expect(actions[1] == .photos)
        #expect(actions[2] == .emojis)
    }
}

// MARK: - ToolbarViewDomain.Action Tests

@Suite("ToolbarViewDomain.Action Tests")
struct ToolbarViewDomainActionTests {
    @Test("Action has all expected cases")
    func action_hasCases() {
        _ = ToolbarView.ToolbarViewDomain.Action.undo
        _ = ToolbarView.ToolbarViewDomain.Action.redo
        _ = ToolbarView.ToolbarViewDomain.Action.colors
        _ = ToolbarView.ToolbarViewDomain.Action.photos
        _ = ToolbarView.ToolbarViewDomain.Action.pictures
        _ = ToolbarView.ToolbarViewDomain.Action.emojis
        _ = ToolbarView.ToolbarViewDomain.Action.decals
        _ = ToolbarView.ToolbarViewDomain.Action.webResources
        _ = ToolbarView.ToolbarViewDomain.Action.spacer
        _ = ToolbarView.ToolbarViewDomain.Action.tips

        #expect(true)
    }

    @Test("Action has icon for each case")
    func action_hasIcon() {
        let actions: [ToolbarView.ToolbarViewDomain.Action] = [
            .colors, .photos, .pictures, .emojis, .undo, .redo, .tips,
        ]

        for action in actions {
            #expect(!action.icon.isEmpty || action == .spacer)
        }
    }

    @Test("Action has tag for each case")
    func action_hasTag() {
        let actions: [ToolbarView.ToolbarViewDomain.Action] = [
            .colors, .photos, .pictures, .emojis, .undo, .redo, .tips,
        ]

        for action in actions {
            #expect(action.tag.hasSuffix("Tag"))
        }
    }

    @Test("Action tag is rawValue plus Tag suffix")
    func action_tagFormat() {
        let action = ToolbarView.ToolbarViewDomain.Action.colors

        #expect(action.tag == "colorsTag")
    }

    @Test("Action rawValue is lowercase")
    func action_rawValue() {
        let action = ToolbarView.ToolbarViewDomain.Action.colors

        #expect(action.rawValue == "colors")
    }

    @Test("Action is Equatable")
    func action_equatable() {
        let action1 = ToolbarView.ToolbarViewDomain.Action.colors
        let action2 = ToolbarView.ToolbarViewDomain.Action.colors
        let action3 = ToolbarView.ToolbarViewDomain.Action.photos

        #expect(action1 == action2)
        #expect(action1 != action3)
    }
}
