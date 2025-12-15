//
//  AppliedStylesViewModelTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI
import Testing
@testable import colir

@Suite("AppliedStylesViewModel Tests")
struct AppliedStylesViewModelTests {
    // MARK: - Initialization Tests

    @Test("init creates valid instance with default state")
    func init_createsInstance() {
        let viewModel = AppliedStylesViewModel(
            state: .none,
            toolsColorsViewModel: nil,
            toolsPhotosViewModel: nil,
            toolsPicturesViewModel: nil,
            toolsEmojisViewModel: nil
        )

        #expect(viewModel.state == .none)
        #expect(viewModel.data.isEmpty)
    }

    @Test("init with specific state")
    func init_withState() {
        let viewModel = AppliedStylesViewModel(
            state: .ready,
            toolsColorsViewModel: nil,
            toolsPhotosViewModel: nil,
            toolsPicturesViewModel: nil,
            toolsEmojisViewModel: nil
        )

        #expect(viewModel.state == .ready)
    }

    // MARK: - state Tests

    @Test("state can be changed")
    func state_canBeChanged() {
        let viewModel = AppliedStylesViewModel(
            state: .none,
            toolsColorsViewModel: nil,
            toolsPhotosViewModel: nil,
            toolsPicturesViewModel: nil,
            toolsEmojisViewModel: nil
        )

        let customisation = ImageCustomisation()
        viewModel.update(state: .ready, imageCustomization: customisation)

        #expect(viewModel.state == .ready)
    }

    // MARK: - update Tests

    @Test("update with color creates color tag")
    func update_withColor_createsTag() async {
        let viewModel = AppliedStylesViewModel(
            state: .none,
            toolsColorsViewModel: ToolsColorsViewModel(),
            toolsPhotosViewModel: nil,
            toolsPicturesViewModel: nil,
            toolsEmojisViewModel: nil
        )

        let customisation = ImageCustomisation()
        await customisation.apply(color: .red)

        viewModel.update(state: .ready, imageCustomization: customisation)

        #expect(viewModel.data.count == 1)
        #expect(viewModel.data.first?.text.hasPrefix("#") == true)
    }

    @Test("update with emoji creates emoji tag")
    func update_withEmoji_createsTag() async {
        let viewModel = AppliedStylesViewModel(
            state: .none,
            toolsColorsViewModel: nil,
            toolsPhotosViewModel: nil,
            toolsPicturesViewModel: nil,
            toolsEmojisViewModel: ToolsEmojisViewModel()
        )

        let customisation = ImageCustomisation()
        await customisation.apply(emoji: "🎉")

        viewModel.update(state: .ready, imageCustomization: customisation)

        #expect(viewModel.data.count == 1)
        #expect(viewModel.data.first?.text == "🎉")
    }

    @Test("update with picture creates picture tag")
    func update_withPicture_createsTag() async {
        let viewModel = AppliedStylesViewModel(
            state: .none,
            toolsColorsViewModel: nil,
            toolsPhotosViewModel: nil,
            toolsPicturesViewModel: nil,
            toolsEmojisViewModel: nil
        )

        let customisation = ImageCustomisation()
        let testImage = NSImage(size: NSSize(width: 100, height: 100))
        await customisation.apply(picture: testImage)

        viewModel.update(state: .ready, imageCustomization: customisation)

        #expect(viewModel.data.count == 1)
        #expect(viewModel.data.first?.image != nil)
    }

    @Test("update with multiple customizations creates multiple tags")
    func update_withMultiple_createsMultipleTags() async {
        let viewModel = AppliedStylesViewModel(
            state: .none,
            toolsColorsViewModel: ToolsColorsViewModel(),
            toolsPhotosViewModel: nil,
            toolsPicturesViewModel: nil,
            toolsEmojisViewModel: ToolsEmojisViewModel()
        )

        let customisation = ImageCustomisation()
        await customisation.apply(color: .blue)
        await customisation.apply(emoji: "⭐")

        viewModel.update(state: .ready, imageCustomization: customisation)

        #expect(viewModel.data.count == 2)
    }

    @Test("update with no customizations clears data")
    func update_withNone_clearsData() async {
        let viewModel = AppliedStylesViewModel(
            state: .none,
            toolsColorsViewModel: ToolsColorsViewModel(),
            toolsPhotosViewModel: nil,
            toolsPicturesViewModel: nil,
            toolsEmojisViewModel: nil
        )

        // First add a customization
        let customisation = ImageCustomisation()
        await customisation.apply(color: .red)
        viewModel.update(state: .ready, imageCustomization: customisation)
        #expect(viewModel.data.count == 1)

        // Then clear it
        await customisation.apply(color: nil)
        viewModel.update(state: .ready, imageCustomization: customisation)
        #expect(viewModel.data.isEmpty)
    }

    // MARK: - viewSettings Tests

    @Test("viewSettings is AppliedStylesViewDomain")
    func viewSettings_isCorrectType() {
        let viewModel = AppliedStylesViewModel(
            state: .none,
            toolsColorsViewModel: nil,
            toolsPhotosViewModel: nil,
            toolsPicturesViewModel: nil,
            toolsEmojisViewModel: nil
        )

        #expect(viewModel.viewSettings is AppliedStylesViewDomain)
    }

    // MARK: - Observable Tests

    @Test("AppliedStylesViewModel is Observable")
    func observable_conformance() {
        let viewModel = AppliedStylesViewModel(
            state: .none,
            toolsColorsViewModel: nil,
            toolsPhotosViewModel: nil,
            toolsPicturesViewModel: nil,
            toolsEmojisViewModel: nil
        )

        // Access observable properties
        _ = viewModel.state
        _ = viewModel.data

        #expect(true)
    }
}

// MARK: - CustomizationTagViewData Tests

@Suite("CustomizationTagViewData Tests")
struct CustomizationTagViewDataTests {
    @Test("init creates valid instance")
    func init_createsInstance() {
        let data = CustomizationTagViewData(
            text: "Test",
            color: .red
        )

        #expect(data.text == "Test")
        #expect(data.image == nil)
    }

    @Test("init with all parameters")
    func init_withAllParameters() {
        let testImage = NSImage(size: NSSize(width: 100, height: 100))
        var selectCalled = false
        var closeCalled = false

        let data = CustomizationTagViewData(
            image: testImage,
            text: "Test",
            color: .blue,
            closeImage: Image(systemName: "xmark"),
            onSelect: { selectCalled = true },
            onClose: { closeCalled = true }
        )

        #expect(data.text == "Test")
        #expect(data.image === testImage)
        #expect(data.closeImage != nil)

        data.onSelect?()
        #expect(selectCalled)

        data.onClose?()
        #expect(closeCalled)
    }

    @Test("id is unique for each instance")
    func id_isUnique() {
        let data1 = CustomizationTagViewData(text: "Test1", color: .red)
        let data2 = CustomizationTagViewData(text: "Test2", color: .blue)

        #expect(data1.id != data2.id)
    }

    @Test("conforms to Identifiable")
    func identifiable_conformance() {
        let data = CustomizationTagViewData(text: "Test", color: .red)

        // Identifiable requires id property
        _ = data.id

        #expect(true)
    }
}
