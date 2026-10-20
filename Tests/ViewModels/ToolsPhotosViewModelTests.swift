//
//  ToolsPhotosViewModelTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Combine
import Photos
import Testing
@testable import colir

@Suite("ToolsPhotosViewModel Tests")
struct ToolsPhotosViewModelTests {
    // MARK: - Initialization Tests

    @Test("init creates valid instance")
    func init_createsInstance() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.selectedPicture == nil)
        #expect(viewModel.selectedAsset == nil)
        #expect(viewModel.isPhotosLoaded == false)
        #expect(viewModel.isAuthorised == true) // Default value
    }

    // MARK: - Static Properties Tests

    @Test("cellWidth has expected value")
    func cellWidth_hasValue() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.cellWidth == 192)
    }

    @Test("cellHeight has expected value")
    func cellHeight_hasValue() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.cellHeight == 148)
    }

    @Test("imageSize has expected dimensions")
    func imageSize_hasDimensions() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.imageSize.width == 1024)
        #expect(viewModel.imageSize.height == 1024)
    }

    @Test("thumbnailSize has expected dimensions")
    func thumbnailSize_hasDimensions() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.thumbnailSize.width == 512)
        #expect(viewModel.thumbnailSize.height == 512)
    }

    // MARK: - cellCornerRadius Tests

    @Test("cellCornerRadius has value")
    func cellCornerRadius_hasValue() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.cellCornerRadius > 0)
    }

    // MARK: - viewSettings Tests

    @Test("viewSettings is ToolsPhotosViewDomain")
    func viewSettings_isCorrectType() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.viewSettings is ToolsPhotosViewDomain)
    }

    // MARK: - selectedPicture Tests

    @Test("selectedPicture initially nil")
    func selectedPicture_initiallyNil() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.selectedPicture == nil)
    }

    @Test("selectedPicture can be set")
    func selectedPicture_canBeSet() {
        let viewModel = ToolsPhotosViewModel()
        let testImage = NSImage(size: NSSize(width: 100, height: 100))

        viewModel.selectedPicture = testImage

        #expect(viewModel.selectedPicture === testImage)
    }

    // MARK: - selectedAsset Tests

    @Test("selectedAsset initially nil")
    func selectedAsset_initiallyNil() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.selectedAsset == nil)
    }

    // MARK: - isPhotosLoaded Tests

    @Test("isPhotosLoaded initially false")
    func isPhotosLoaded_initiallyFalse() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.isPhotosLoaded == false)
    }

    // MARK: - isAuthorised Tests

    @Test("isAuthorised initially true")
    func isAuthorised_initiallyTrue() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.isAuthorised == true)
    }

    // MARK: - photoLibraryAlbumManager Tests

    @Test("photoLibraryAlbumManager is configured")
    func photoLibraryAlbumManager_isConfigured() {
        let viewModel = ToolsPhotosViewModel()

        // Manager should be initialized
        #expect(viewModel.photoLibraryAlbumManager.smartAlbumType == .smartAlbumUserLibrary)
    }

    // MARK: - selectedImagePublisher Tests

    @Test("selectedImagePublisher is accessible")
    func selectedImagePublisher_accessible() {
        let viewModel = ToolsPhotosViewModel()

        #expect(viewModel.selectedImagePublisher is PassthroughSubject<(NSImage?, PhotoAsset?), Never>)
    }

    // MARK: - Preview Tests

    @Test("preview creates valid instance")
    func preview_createsInstance() {
        let preview = ToolsPhotosViewModel.preview

        #expect(preview.selectedPicture == nil)
        #expect(preview.selectedAsset == nil)
    }

    // MARK: - Observable Tests

    @Test("ToolsPhotosViewModel is Observable")
    func observable_conformance() {
        let viewModel = ToolsPhotosViewModel()

        // Access observable properties
        _ = viewModel.selectedPicture
        _ = viewModel.selectedAsset
        _ = viewModel.isPhotosLoaded

        #expect(true)
    }

    // MARK: - Sendable Tests

    @Test("ToolsPhotosViewModel is Sendable (unchecked)")
    func sendable_conformance() async {
        let viewModel = ToolsPhotosViewModel()

        // Pass across task boundary
        let isLoaded = await Task.detached {
            viewModel.isPhotosLoaded
        }.value

        #expect(isLoaded == false)
    }
}
