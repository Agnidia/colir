//
//  ImageDto.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI

struct ImageUndoDto {
    let originalImage: [ImageDto.ImageSize: NSImage]
    let colorizedImage: [ImageDto.ImageSize: NSImage]
    let picturedImage: [ImageDto.ImageSize: NSImage]
    let emojiedImage: [ImageDto.ImageSize: NSImage]
    let outputImage: [ImageDto.ImageSize: NSImage]
    
    let customizations: ImageCustomizationUndoDto
}

final public class ImageDto: ObservableObject {
    
    enum ImageState: Equatable {
        case none
        case initieted
        case ready
        case processing(value: Float)
        case error
        case preview
    }
    
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
        
        static var allCases: [ImageDto.ImageSize] = [.s256, .s16, .s16x2, .s32, .s32x2, .s128, .s128x2, .s256x2, .s512, .s512x2]
        
        var dimension: CGFloat {
            switch self {
            case .s16, .s16x2:
                16
            case .s32, .s32x2:
                32
            case .s128, .s128x2:
                128
            case .s256, .s256x2:
                256
            case .s512, .s512x2:
                512
            }
        }
        
        var pixel: CGFloat {
            switch self {
            case .s16:
                16
            case .s16x2, .s32:
                32
            case .s32x2:
                64
            case .s128:
                128
            case .s128x2, .s256:
                256
            case .s256x2, .s512:
                512
            case .s512x2:
                1024
            }
        }
        
        var progress: Float {
            switch self {
            case .s16:
                20
            case .s16x2:
                30
            case .s32:
                40
            case .s32x2:
                50
            case .s128:
                60
            case .s128x2:
                70
            case .s256:
                10
            case .s256x2:
                80
            case .s512:
                90
            case .s512x2:
                100
            }
        }
    }
    
    // original images
    
    private static var dummyImages = ImageSize.allCases.reduce([ImageSize: NSImage]()) {
        var result = $0
        result[$1] = NSImage()
        return result
    }
    
    private lazy var originalImage: [ImageSize: NSImage] = ImageDto.dummyImages
    
    private lazy var colorizedImage: [ImageSize: NSImage] = ImageDto.dummyImages
    
    private lazy var picturedImage: [ImageSize: NSImage] = ImageDto.dummyImages
    
    private lazy var emojiedImage: [ImageSize: NSImage] = ImageDto.dummyImages
    
    private lazy var outputImage: [ImageSize: NSImage] = ImageDto.dummyImages
    
    var undoItems: ImageUndoDto {
        ImageUndoDto(originalImage: originalImage, colorizedImage: colorizedImage, picturedImage: picturedImage, emojiedImage: emojiedImage, outputImage: outputImage, customizations: customizations.undoItems)
    }
    
    func update(from undoItems: ImageUndoDto) {
        originalImage = undoItems.originalImage
        colorizedImage = undoItems.colorizedImage
        picturedImage = undoItems.picturedImage
        emojiedImage = undoItems.emojiedImage
        outputImage = undoItems.outputImage
        
        customizations.update(from: undoItems.customizations)
    }
    
    private(set) var url: URL?
    
    @Published private(set) var state: ImageState = .none
    @Published private(set) var progressValue: Float = 0 {
        didSet {
            state = .processing(value: progressValue)
        }
    }
    
    private(set) lazy var stateBinding = Binding<ImageState>(
        get: { [weak self] in self?.state ?? .none },
        set: { [weak self] newState in
            self?.state = newState
        }
    )
    
    var isValid: Bool {
        url != nil && state == .ready
    }
    
    private(set) var customizations: ImageCustomization
    
    convenience init() {
        self.init(url: nil, image: .init(), customizations: .init())
    }
    
    init(url: URL? = nil, image: NSImage, customizations: ImageCustomization) {
        self.customizations = customizations
        
        if image.isValid {
            Task {
                await updateOriginal(url: url, image: image)
            }
        }
    }
    
    func prepareForUpdate() {
        progressValue = 0
    }
    
    func update(customizations: ImageCustomization) async throws {
        
        self.customizations = customizations
        
        for size in ImageSize.allCases {
            await process(original: originalImage[size]!, with: size)
        }
    }
    
    private func process(original: NSImage, with size: ImageSize, notifyReady: Bool = true) async {
        let cImage = await customizations.updateColor(for: original, size: size, updatedImage: colorizedImage[size]!)
        colorizedImage[size] = cImage
        
        let pImage = await customizations.updatePicture(for: cImage, size: size, updatedImage: picturedImage[size]!)
        picturedImage[size] = pImage
        
        let eImage = await customizations.updateEmoji(for: pImage, size: size, updatedImage: emojiedImage[size]!)
        emojiedImage[size] = eImage
        
        outputImage[size] = eImage
        
        progressValue = size.progress
        
        if size == .s256 {
            state = .preview
        } else if size == .s512x2 {
            state = notifyReady ? .ready : .initieted
        }
    }
    
    func updateOriginal(url: URL?, image: NSImage) async {
        
        self.url = url
        
        self.customizations = .init()
        
        func imageFor(size: ImageSize, in images: [NSImageRep]) -> NSImage {
            let pixel = Int(size.pixel)
            let dimension = size.dimension
            
            if let imageRep = images.first(where: { $0.size.width == dimension && $0.pixelsWide == pixel }), let cgImage = imageRep.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                return NSImage(cgImage: cgImage, size: .init(width: dimension, height: dimension))
            } else {
                assert(false, "wrong image for size: \(dimension), pixels: \(pixel)")
                return .init()
            }
        }
        
        let images = image.representations
        
        for size in ImageSize.allCases {
            let oImage = imageFor(size: size, in: images)
            originalImage[size] = oImage
            
            await process(original: oImage, with: size, notifyReady: false)
        }
    }
    
    @ViewBuilder
    var preview: some View {
        switch state {
        case .none:
            EmptyView()
        case .ready, .preview, .initieted:
            Image(nsImage: outputImage[.s256]!)
                .resizable()
        case .processing(let progress):
            if progress < 20 {
                Image(nsImage: outputImage[.s256]!)
                    .resizable()
                    .blur(radius: 5.0)
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Image(nsImage: outputImage[.s256]!)
                    .resizable()
            }
        case .error:
            EmptyView()
        }
    }
}
