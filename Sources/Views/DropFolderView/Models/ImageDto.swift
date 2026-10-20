//
//  ImageDto.swift
//
//  Created on 05.11.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import SwiftUI

/// A data transfer object for storing the state of various image types for undo functionality.
struct ImageUndoDto {
    let originalImage: [ImageDto.ImageSize: NSImage]
    let colorisedImage: [ImageDto.ImageSize: NSImage]
    let picturedImage: [ImageDto.ImageSize: NSImage]
    let emojiedImage: [ImageDto.ImageSize: NSImage]
    let outputImage: [ImageDto.ImageSize: NSImage]

    let customisations: ImageCustomisationUndoDto
}

public final class ImageDto: ObservableObject, @unchecked Sendable {
    /// Represents the current state of the image processing.
    enum ImageState: Equatable {
        case none
        case initiated
        case ready
        case processing(value: Float)
        case error
        case preview
    }

    /// Represents different image sizes and their properties.
    enum ImageSize: CaseIterable {
        case s16
        case s16x2

        case s32
        case s32x2

        case s128
        case s128x2

        case s256
        case s256x2

        case s512
        case s512x2

        static let processingCases: [ImageDto.ImageSize] = [.s256, .s16, .s16x2, .s32, .s32x2, .s128, .s128x2, .s256x2, .s512, .s512x2]

        static let allCases: [ImageDto.ImageSize] = [.s16, .s16x2, .s32, .s32x2, .s128, .s128x2, .s256, .s256x2, .s512, .s512x2]

        /// Returns the dimension (size) of the image for this `ImageSize`.
        var dimension: CGFloat {
            switch self {
            case .s16, .s16x2: 16
            case .s32, .s32x2: 32
            case .s128, .s128x2: 128
            case .s256, .s256x2: 256
            case .s512, .s512x2: 512
            }
        }

        /// Returns the pixel count of the image for this `ImageSize`.
        var pixel: CGFloat {
            switch self {
            case .s16: 16
            case .s16x2, .s32: 32
            case .s32x2: 64
            case .s128: 128
            case .s128x2, .s256: 256
            case .s256x2, .s512: 512
            case .s512x2: 1024
            }
        }

        /// Returns the processing progress associated with this `ImageSize`.
        var progress: Float {
            switch self {
            case .s16: 20
            case .s16x2: 30
            case .s32: 40
            case .s32x2: 50
            case .s128: 60
            case .s128x2: 70
            case .s256: 10
            case .s256x2: 80
            case .s512: 90
            case .s512x2: 100
            }
        }
    }

    // Placeholder images for initialization.
    private static var dummyImages: [ImageSize: NSImage] {
        ImageSize.processingCases.reduce([ImageSize: NSImage]()) {
            var result = $0
            result[$1] = NSImage()
            return result
        }
    }

    // Various image states.
    private lazy var originalImage: [ImageSize: NSImage] = ImageDto.dummyImages
    private var templateImage: [ImageSize: NSImage] {
        let images = NSWorkspace.shared.icon(for: .folder).representations
        var templates: [ImageSize: NSImage] = .init()
        for size in ImageSize.processingCases {
            let oImage = Self.imageFor(size: size, in: images)
            templates[size] = oImage
        }

        return templates
    }

    private lazy var colorisedImage: [ImageSize: NSImage] = ImageDto.dummyImages
    private lazy var picturedImage: [ImageSize: NSImage] = ImageDto.dummyImages
    private lazy var emojiedImage: [ImageSize: NSImage] = ImageDto.dummyImages
    private lazy var outputImage: [ImageSize: NSImage] = ImageDto.dummyImages

    var model: ImageModel {
        .init(outputImage: outputImage)
    }

    /// Array of output images.
    var outputImages: [NSImage] {
        ImageSize.allCases.compactMap { outputImage[$0] }
    }

    /// Provides undo data for the images and customizations.
    var undoItems: ImageUndoDto {
        ImageUndoDto(originalImage: originalImage, colorisedImage: colorisedImage, picturedImage: picturedImage, emojiedImage: emojiedImage, outputImage: outputImage, customisations: customisations.undoItems)
    }

    /// Updates the image data from the provided undo items.
    func update(from undoItems: ImageUndoDto) {
        originalImage = undoItems.originalImage
        colorisedImage = undoItems.colorisedImage
        picturedImage = undoItems.picturedImage
        emojiedImage = undoItems.emojiedImage
        outputImage = undoItems.outputImage

        customisations.update(from: undoItems.customisations)
    }

    /// URL of the image file.
    private(set) var url: URL?

    /// Current state of image processing.
    @Published private(set) var state: ImageState = .none

    /// Progress value of the image processing.
    @Published private(set) var progressValue: Float = .zero {
        didSet {
            state = .processing(value: progressValue)
        }
    }

    /// Binding for observing and setting the image state.
    private(set) lazy var stateBinding = Binding<ImageState>(
        get: getState,
        set: setState
    )

    private func getState() -> ImageState {
        state
    }

    private func setState(_ newState: ImageState) {
        state = newState
    }

    /// Indicates whether the image processing is complete and the image is valid.
    var isValid: Bool {
        url != nil && state == .ready
    }

    /// Customizations applied to the image.
    private(set) var customisations: ImageCustomisation

    /// Initializes a new `ImageDto` instance with default values.
    convenience init() {
        self.init(url: nil, image: .init(), customisations: .init())
    }

    /// Initializes a new `ImageDto` instance with specified URL, image, and customizations.
    ///
    /// - Parameters:
    ///   - url: The URL of the image file.
    ///   - image: The initial image.
    ///   - customisations: The customizations applied to the image.
    init(url: URL? = nil, image: NSImage, customisations: ImageCustomisation) {
        self.customisations = customisations

        if image.isValid {
            Task { [url, image, weak self] in
                await self?.updateOriginal(url: url, image: image)
            }
        }
    }

    /// Prepares the instance for an update by resetting the progress value.
    func prepareForUpdate() {
        progressValue = .zero
    }

    /// Updates the image using the specified customizations.
    ///
    /// - Parameter customisations: The customizations to apply to the image.
    /// - Throws: An error if the update fails.
    func update(customisations: ImageCustomisation) async throws {
        self.customisations = customisations

        for size in ImageSize.processingCases {
            await process(original: templateImage[size]!, with: size)
        }
    }

    /// Processes the image with customizations for a specified size.
    ///
    /// - Parameters:
    ///   - original: The original image to process.
    ///   - size: The size of the image to process.
    ///   - notifyReady: A Boolean value indicating whether to notify that processing is complete.
    private func process(original: NSImage, with size: ImageSize, notifyReady: Bool = true) async {
        let cImage = await customisations.updateColor(for: original, size: size, updatedImage: colorisedImage[size]!)
        colorisedImage[size] = cImage

        let pImage = await customisations.updatePicture(for: cImage, size: size, updatedImage: picturedImage[size]!)
        picturedImage[size] = pImage

        let eImage = await customisations.updateEmoji(for: pImage, size: size, updatedImage: emojiedImage[size]!)
        emojiedImage[size] = eImage

        outputImage[size] = eImage

        progressValue = size.progress

        if size == .s256 {
            state = .preview
        } else if size == .s512x2 {
            state = notifyReady ? .ready : .initiated
        }
    }

    private static func imageFor(size: ImageSize, in images: [NSImageRep]) -> NSImage {
        let pixel = Int(size == .s512x2 ? ImageSize.s512.pixel : size.pixel) // max size is 512x512
        let dimension = size.dimension

        if let imageRep = images.first(where: { $0.size.width == dimension && $0.pixelsWide == pixel }), let cgImage = imageRep.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            return NSImage(cgImage: cgImage, size: .init(width: dimension, height: dimension))
        } else {
            assertionFailure("wrong image for size: \(dimension), pixels: \(pixel)")
            return .init()
        }
    }

    /// Updates the original image and processes it for different sizes.
    ///
    /// - Parameters:
    ///   - url: The URL of the image file.
    ///   - image: The new image to use.
    func updateOriginal(url: URL?, image: NSImage) async {
        self.url = url

        customisations = .init()

        let images = image.representations

        for size in ImageSize.processingCases {
            let oImage = Self.imageFor(size: size, in: images)
            originalImage[size] = oImage

            await process(original: oImage, with: size, notifyReady: false)
        }
    }

    @MainActor
    @ViewBuilder
    var preview: some View {
        switch state {
        case .none:
            EmptyView()
        case .ready, .preview, .initiated:
            if let image = outputImage[.s256] {
                Image(nsImage: image)
                    .resizable()
            }
        case .processing(let progress):
            if progress < 20 {
                if let image = outputImage[.s256] {
                    Image(nsImage: image)
                        .resizable()
                        .blur(radius: 5.0)
                }
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                if let image = outputImage[.s256] {
                    Image(nsImage: image)
                        .resizable()
                }
            }
        case .error:
            EmptyView()
        }
    }
}

struct ImageModel: Hashable {
    var outputImage: [ImageDto.ImageSize: NSImage]

    var previewImage: NSImage? {
        outputImage[.s256]
    }
}
