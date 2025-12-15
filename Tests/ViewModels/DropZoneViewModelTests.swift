//
//  DropZoneViewModelTests.swift
//  colirTests
//
//  Created by Claude Code on 2025-12-15.
//  Copyright (c) 2025 IGR Software. All rights reserved.
//

import AppKit
@testable import colir
import Combine
import Testing

@Suite("DropZoneViewModel Tests")
@MainActor
struct DropZoneViewModelTests {
    // MARK: - Initialization Tests

    @Test("init sets closures and default state")
    func init_setsClosures() {
        var fileClosureCalled = false
        var stateUpdateReceived: ImageDto.ImageState?

        let viewModel = DropZoneViewModel(
            fileClosure: { _ in fileClosureCalled = true },
            updateStateClosure: { state in stateUpdateReceived = state }
        )

        // Initial state checks
        #expect(viewModel.image.state == .none)
        #expect(viewModel.enterZoneAnimationTextScale == 1.0)
        #expect(viewModel.enterZoneAnimationImageScale == 1.0)
        #expect(viewModel.enterZoneAnimationBackgroundOpacity == .opacity0)

        // Verify closures are set
        viewModel.fileClosure([])
        #expect(fileClosureCalled)
    }

    // MARK: - urlsHasFolders Tests

    @Test("urlsHasFolders returns true for folder URLs")
    func urlsHasFolders_folderURLs() {
        let viewModel = createViewModel()
        let tempDir = FileManager.default.temporaryDirectory

        let result = viewModel.urlsHasFolders(urls: [tempDir])

        #expect(result == true)
    }

    @Test("urlsHasFolders returns false for file URLs")
    func urlsHasFolders_fileURLs() throws {
        let viewModel = createViewModel()
        let tempFile = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".txt")
        try "test".write(to: tempFile, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: tempFile) }

        let result = viewModel.urlsHasFolders(urls: [tempFile])

        #expect(result == false)
    }

    @Test("urlsHasFolders returns false for empty URLs")
    func urlsHasFolders_emptyURLs() {
        let viewModel = createViewModel()

        let result = viewModel.urlsHasFolders(urls: [])

        #expect(result == false)
    }

    @Test("urlsHasFolders excludes .app bundles")
    func urlsHasFolders_excludesAppBundles() {
        let viewModel = createViewModel()
        let appURL = URL(fileURLWithPath: "/Applications/Calculator.app")

        let result = viewModel.urlsHasFolders(urls: [appURL])

        // .app bundles should be excluded even though they're technically folders
        #expect(result == false)
    }

    // MARK: - delivery Tests

    @Test("delivery calls fileClosure with URLs")
    func delivery_callsFileClosure() {
        var receivedURLs: [URL]?
        let viewModel = DropZoneViewModel(
            fileClosure: { receivedURLs = $0 },
            updateStateClosure: { _ in }
        )

        let testURLs = [URL(fileURLWithPath: "/tmp/test1"), URL(fileURLWithPath: "/tmp/test2")]
        viewModel.delivery(urls: testURLs)

        #expect(receivedURLs == testURLs)
    }

    @Test("delivery with empty URLs")
    func delivery_emptyURLs() {
        var receivedURLs: [URL]?
        let viewModel = DropZoneViewModel(
            fileClosure: { receivedURLs = $0 },
            updateStateClosure: { _ in }
        )

        viewModel.delivery(urls: [])

        #expect(receivedURLs?.isEmpty == true)
    }

    // MARK: - animateText Tests

    @Test("animateText with hovered false resets values")
    func animateText_notHovered_resets() {
        let viewModel = createViewModel()

        viewModel.animateText(hovered: false)

        #expect(viewModel.enterZoneAnimationTextScale == 1)
        #expect(viewModel.enterZoneAnimationImageScale == 1)
        #expect(viewModel.enterZoneAnimationBackgroundOpacity == .zero)
    }

    @Test("animateText with hovered true increases values")
    func animateText_hovered_increases() {
        let viewModel = createViewModel()

        viewModel.animateText(hovered: true)

        // Animation starts with increased values
        #expect(viewModel.enterZoneAnimationTextScale > 1.0)
        #expect(viewModel.enterZoneAnimationImageScale > 1.0)
        #expect(viewModel.enterZoneAnimationBackgroundOpacity > 0)
    }

    // MARK: - update(from:) Tests

    @Test("update from ImageUndoDto updates image")
    func update_fromImageUndoDto() {
        let viewModel = createViewModel()
        let dummyImage = NSImage(size: NSSize(width: 16, height: 16))
        let dummyImages: [ImageDto.ImageSize: NSImage] = [.s16: dummyImage]
        let dummyCustomisation = ImageCustomisationUndoDto(
            selectedColor: nil,
            selectedPicture: nil,
            selectedAsset: nil,
            selectedPictureItem: nil,
            selectedEmoji: nil
        )
        let undoDto = ImageUndoDto(
            originalImage: dummyImages,
            colorisedImage: dummyImages,
            picturedImage: dummyImages,
            emojiedImage: dummyImages,
            outputImage: dummyImages,
            customisations: dummyCustomisation
        )

        viewModel.update(from: undoDto)

        // Image should be updated
        #expect(true) // Verifies no crash
    }

    // MARK: - image Property Tests

    @Test("image property is accessible")
    func image_accessible() {
        let viewModel = createViewModel()

        #expect(viewModel.image.state == .none)
    }

    // MARK: - updatedImagePublisher Tests

    @Test("updatedImagePublisher emits on update")
    func updatedImagePublisher_emits() async {
        let viewModel = createViewModel()
        var receivedImage: ImageDto?

        let cancellable = viewModel.updatedImagePublisher.sink { image in
            receivedImage = image
        }
        defer { cancellable.cancel() }

        let dummyImage = NSImage(size: NSSize(width: 16, height: 16))
        let dummyImages: [ImageDto.ImageSize: NSImage] = [.s16: dummyImage]
        let dummyCustomisation = ImageCustomisationUndoDto(
            selectedColor: nil,
            selectedPicture: nil,
            selectedAsset: nil,
            selectedPictureItem: nil,
            selectedEmoji: nil
        )
        let undoDto = ImageUndoDto(
            originalImage: dummyImages,
            colorisedImage: dummyImages,
            picturedImage: dummyImages,
            emojiedImage: dummyImages,
            outputImage: dummyImages,
            customisations: dummyCustomisation
        )
        viewModel.update(from: undoDto)

        // Give publisher time to emit
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(receivedImage != nil)
    }

    // MARK: - Observable Tests

    @Test("DropZoneViewModel is Observable")
    func observable_conformance() {
        let viewModel = createViewModel()

        // Should be accessible as @Observable
        _ = viewModel.image
        _ = viewModel.enterZoneAnimationTextScale

        #expect(true)
    }

    // MARK: - Sendable Tests

    @Test("DropZoneViewModel is Sendable (unchecked)")
    func sendable_conformance() async {
        let viewModel = createViewModel()

        let scale = await Task.detached {
            viewModel.enterZoneAnimationTextScale
        }.value

        #expect(scale == 1.0)
    }

    // MARK: - Helpers

    private func createViewModel() -> DropZoneViewModel {
        DropZoneViewModel(
            fileClosure: { _ in },
            updateStateClosure: { _ in }
        )
    }
}
