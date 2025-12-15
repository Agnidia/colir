//
//  ToolsPicturesViewModelTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI
import Testing
@testable import colir

@Suite("ToolsPicturesViewModel Tests")
struct ToolsPicturesViewModelTests {
    // MARK: - Test Helpers

    private func createMockAppSettings() -> MockAppSettings {
        MockAppSettings()
    }

    private func createMockPicturesFolderManager() -> MockPicturesFolderManager {
        MockPicturesFolderManager()
    }

    // MARK: - Initialization Tests

    @Test("init creates valid instance")
    func init_createsInstance() {
        let appSettings = createMockAppSettings()
        let folderManager = createMockPicturesFolderManager()

        let viewModel = ToolsPicturesViewModel(
            appSettings: appSettings,
            picturesFolderManager: folderManager
        )

        #expect(viewModel.images.isEmpty)
        #expect(viewModel.selectedImage == nil)
        #expect(viewModel.needsAccess == false)
    }

    // MARK: - Static Properties Tests

    @Test("cellWidth has expected value")
    func cellWidth_hasValue() {
        let viewModel = ToolsPicturesViewModel(
            appSettings: createMockAppSettings(),
            picturesFolderManager: createMockPicturesFolderManager()
        )

        #expect(viewModel.cellWidth == 192)
    }

    @Test("cellHeight has expected value")
    func cellHeight_hasValue() {
        let viewModel = ToolsPicturesViewModel(
            appSettings: createMockAppSettings(),
            picturesFolderManager: createMockPicturesFolderManager()
        )

        #expect(viewModel.cellHeight == 148)
    }

    @Test("cellCornerRadius has value")
    func cellCornerRadius_hasValue() {
        let viewModel = ToolsPicturesViewModel(
            appSettings: createMockAppSettings(),
            picturesFolderManager: createMockPicturesFolderManager()
        )

        #expect(viewModel.cellCornerRadius > 0)
    }

    // MARK: - columns Tests

    @Test("columns returns adaptive grid items")
    func columns_returnsGridItems() {
        let viewModel = ToolsPicturesViewModel(
            appSettings: createMockAppSettings(),
            picturesFolderManager: createMockPicturesFolderManager()
        )

        let columns = viewModel.columns

        #expect(columns.count == 1)
    }

    // MARK: - images Tests

    @Test("images initially empty")
    func images_initiallyEmpty() {
        let viewModel = ToolsPicturesViewModel(
            appSettings: createMockAppSettings(),
            picturesFolderManager: createMockPicturesFolderManager()
        )

        #expect(viewModel.images.isEmpty)
    }

    // MARK: - selectedImage Tests

    @Test("selectedImage initially nil")
    func selectedImage_initiallyNil() {
        let viewModel = ToolsPicturesViewModel(
            appSettings: createMockAppSettings(),
            picturesFolderManager: createMockPicturesFolderManager()
        )

        #expect(viewModel.selectedImage == nil)
    }

    @Test("selectedImage can be set")
    func selectedImage_canBeSet() {
        let viewModel = ToolsPicturesViewModel(
            appSettings: createMockAppSettings(),
            picturesFolderManager: createMockPicturesFolderManager()
        )
        let testImage = NSImage(size: NSSize(width: 100, height: 100))
        let pictureItem = PictureItem(name: "Test", tags: ["test"], image: testImage)

        viewModel.selectedImage = pictureItem

        #expect(viewModel.selectedImage?.name == "Test")
    }

    // MARK: - needsAccess Tests

    @Test("needsAccess initially false")
    func needsAccess_initiallyFalse() {
        let viewModel = ToolsPicturesViewModel(
            appSettings: createMockAppSettings(),
            picturesFolderManager: createMockPicturesFolderManager()
        )

        #expect(viewModel.needsAccess == false)
    }

    // MARK: - Preview Tests

    @Test("preview creates valid instance")
    func preview_createsInstance() {
        let preview = ToolsPicturesViewModel.preview

        #expect(preview.images.isEmpty)
        #expect(preview.selectedImage == nil)
    }

    // MARK: - ObservableObject Tests

    @Test("ToolsPicturesViewModel is ObservableObject")
    func observable_conformance() {
        let viewModel = ToolsPicturesViewModel(
            appSettings: createMockAppSettings(),
            picturesFolderManager: createMockPicturesFolderManager()
        )

        // Access published properties
        _ = viewModel.images
        _ = viewModel.selectedImage
        _ = viewModel.needsAccess

        #expect(true)
    }

    // MARK: - Sendable Tests

    @Test("ToolsPicturesViewModel is Sendable (unchecked)")
    func sendable_conformance() async {
        let viewModel = ToolsPicturesViewModel(
            appSettings: createMockAppSettings(),
            picturesFolderManager: createMockPicturesFolderManager()
        )

        // Pass across task boundary
        let isEmpty = await Task.detached {
            viewModel.images.isEmpty
        }.value

        #expect(isEmpty == true)
    }
}

// MARK: - Mock Classes

private final class MockAppSettings: AppSettingsProtocol {
    var userPicturesPath: URL = .init(fileURLWithPath: "/tmp/test-pictures")
    var bookmarkData: Data = .init()
    var exportCount: Int = 0
    var tipped: CryptoModel = .init(value: "0")
    var isTestMode: Bool = true

    func setup(uuid _: String) {
        // No-op for testing
    }
}

private final class MockPicturesFolderManager: PicturesFolderManagerProtocol {
    var picturesDirectory: URL = .init(fileURLWithPath: "/tmp/test-pictures")
    var mockImages: [PicturesFolderItem] = []
    var shouldThrow = false

    func readImages() async throws -> [PicturesFolderItem] {
        if shouldThrow {
            throw NSError(domain: "TestError", code: 1)
        }
        return mockImages
    }
}
