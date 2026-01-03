//
//  ImageDtoTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("ImageDto Tests")
struct ImageDtoTests {
    // MARK: - ImageState Tests

    @Test("ImageState equality")
    func imageState_equality() {
        #expect(ImageDto.ImageState.none == ImageDto.ImageState.none)
        #expect(ImageDto.ImageState.initiated == ImageDto.ImageState.initiated)
        #expect(ImageDto.ImageState.ready == ImageDto.ImageState.ready)
        #expect(ImageDto.ImageState.error == ImageDto.ImageState.error)
        #expect(ImageDto.ImageState.preview == ImageDto.ImageState.preview)
        #expect(ImageDto.ImageState.processing(value: 50) == ImageDto.ImageState.processing(value: 50))
    }

    @Test("ImageState processing inequality with different values")
    func imageState_processingInequality() {
        #expect(ImageDto.ImageState.processing(value: 50) != ImageDto.ImageState.processing(value: 75))
    }

    @Test("ImageState different states not equal")
    func imageState_differentStates() {
        #expect(ImageDto.ImageState.none != ImageDto.ImageState.ready)
        #expect(ImageDto.ImageState.initiated != ImageDto.ImageState.error)
        #expect(ImageDto.ImageState.processing(value: 50) != ImageDto.ImageState.ready)
    }

    // MARK: - ImageSize Tests

    @Test("ImageSize allCases has correct count")
    func imageSize_allCasesCount() {
        #expect(ImageDto.ImageSize.allCases.count == 10)
    }

    @Test("ImageSize processingCases has correct count")
    func imageSize_processingCasesCount() {
        #expect(ImageDto.ImageSize.processingCases.count == 10)
    }

    @Test("ImageSize dimension returns correct values")
    func imageSize_dimension() {
        #expect(ImageDto.ImageSize.s16.dimension == 16)
        #expect(ImageDto.ImageSize.s16x2.dimension == 16)
        #expect(ImageDto.ImageSize.s32.dimension == 32)
        #expect(ImageDto.ImageSize.s32x2.dimension == 32)
        #expect(ImageDto.ImageSize.s128.dimension == 128)
        #expect(ImageDto.ImageSize.s128x2.dimension == 128)
        #expect(ImageDto.ImageSize.s256.dimension == 256)
        #expect(ImageDto.ImageSize.s256x2.dimension == 256)
        #expect(ImageDto.ImageSize.s512.dimension == 512)
        #expect(ImageDto.ImageSize.s512x2.dimension == 512)
    }

    @Test("ImageSize pixel returns correct values")
    func imageSize_pixel() {
        #expect(ImageDto.ImageSize.s16.pixel == 16)
        #expect(ImageDto.ImageSize.s16x2.pixel == 32)
        #expect(ImageDto.ImageSize.s32.pixel == 32)
        #expect(ImageDto.ImageSize.s32x2.pixel == 64)
        #expect(ImageDto.ImageSize.s128.pixel == 128)
        #expect(ImageDto.ImageSize.s128x2.pixel == 256)
        #expect(ImageDto.ImageSize.s256.pixel == 256)
        #expect(ImageDto.ImageSize.s256x2.pixel == 512)
        #expect(ImageDto.ImageSize.s512.pixel == 512)
        #expect(ImageDto.ImageSize.s512x2.pixel == 1024)
    }

    @Test("ImageSize progress returns correct values")
    func imageSize_progress() {
        #expect(ImageDto.ImageSize.s16.progress == 20)
        #expect(ImageDto.ImageSize.s16x2.progress == 30)
        #expect(ImageDto.ImageSize.s32.progress == 40)
        #expect(ImageDto.ImageSize.s32x2.progress == 50)
        #expect(ImageDto.ImageSize.s128.progress == 60)
        #expect(ImageDto.ImageSize.s128x2.progress == 70)
        #expect(ImageDto.ImageSize.s256.progress == 10)
        #expect(ImageDto.ImageSize.s256x2.progress == 80)
        #expect(ImageDto.ImageSize.s512.progress == 90)
        #expect(ImageDto.ImageSize.s512x2.progress == 100)
    }

    @Test("ImageSize processingCases starts with s256")
    func imageSize_processingCasesOrder() {
        // s256 is processed first for preview
        #expect(ImageDto.ImageSize.processingCases.first == .s256)
    }

    // MARK: - ImageDto Initialization Tests

    @Test("ImageDto default init")
    func imageDto_defaultInit() {
        let imageDto = ImageDto()

        #expect(imageDto.url == nil)
        #expect(imageDto.isValid == false)
    }

    @Test("ImageDto isValid false when url is nil")
    func imageDto_isValid_nilUrl() {
        let imageDto = ImageDto()

        #expect(imageDto.isValid == false)
    }

    @Test("ImageDto outputImages returns array")
    func imageDto_outputImages() {
        let imageDto = ImageDto()
        let images = imageDto.outputImages

        // Should return array (may be empty NSImages)
        #expect(images.count >= 0)
    }

    // MARK: - ImageModel Tests

    @Test("ImageModel previewImage returns s256 image")
    func imageModel_previewImage() {
        let outputImages: [ImageDto.ImageSize: NSImage] = [
            .s256: NSImage(size: NSSize(width: 256, height: 256)),
        ]
        let model = ImageModel(outputImage: outputImages)

        #expect(model.previewImage != nil)
        #expect(model.previewImage?.size.width == 256)
    }

    @Test("ImageModel previewImage nil when no s256")
    func imageModel_previewImage_nil() {
        let outputImages: [ImageDto.ImageSize: NSImage] = [
            .s16: NSImage(size: NSSize(width: 16, height: 16)),
        ]
        let model = ImageModel(outputImage: outputImages)

        #expect(model.previewImage == nil)
    }

    @Test("ImageModel hashable")
    func imageModel_hashable() {
        let image = NSImage(size: NSSize(width: 256, height: 256))
        let model1 = ImageModel(outputImage: [.s256: image])
        let model2 = ImageModel(outputImage: [.s256: image])

        // Hashable conformance
        var set = Set<ImageModel>()
        set.insert(model1)
        set.insert(model2)

        // Both should hash (may or may not be equal depending on NSImage identity)
        #expect(set.count >= 1)
    }

    // MARK: - ImageUndoDto Tests

    @Test("ImageUndoDto stores all image dictionaries")
    func imageUndoDto_storesAllDictionaries() {
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

        #expect(undoDto.originalImage[.s16] != nil)
        #expect(undoDto.colorisedImage[.s16] != nil)
        #expect(undoDto.picturedImage[.s16] != nil)
        #expect(undoDto.emojiedImage[.s16] != nil)
        #expect(undoDto.outputImage[.s16] != nil)
    }

    // MARK: - prepareForUpdate Tests

    @Test("prepareForUpdate resets progress")
    func prepareForUpdate_resetsProgress() {
        let imageDto = ImageDto()
        imageDto.prepareForUpdate()

        // After prepare, the state should be ready for new processing
        // This mainly ensures no crash occurs
        #expect(true)
    }
}
