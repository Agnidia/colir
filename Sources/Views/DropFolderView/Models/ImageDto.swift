//
//  ImageDto.swift
//  colir
//
//  Created by Vitalii P on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI

final public class ImageDto: ObservableObject {
    
    enum ImageState: Equatable {
        case none
        case ready
        case processing(value: Float)
        case error
        case preview
    }
    
    // original images
    
    private var o16: NSImage = .init()
    
    private var o16x2: NSImage = .init()
    
    private var o32: NSImage = .init()
    
    private var o32x2: NSImage = .init()
    
    private var o128: NSImage = .init()
    
    private var o128x2: NSImage = .init()
    
    private var o256: NSImage = .init()
    
    private var o256x2: NSImage = .init()
    
    private var o512: NSImage = .init()
    
    private var o512x2: NSImage = .init()
    
    // processed images
    
    private(set) var i16: NSImage = .init()
    
    private(set) var i16x2: NSImage = .init()
    
    private(set) var i32: NSImage = .init()
    
    private(set) var i32x2: NSImage = .init()
    
    private(set) var i128: NSImage = .init()
    
    private(set) var i128x2: NSImage = .init()
    
    private(set) var i256: NSImage = .init()
    
    private(set) var i256x2: NSImage = .init()
    
    private(set) var i512: NSImage = .init()
    
    private(set) var i512x2: NSImage = .init()
    
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
    
    private(set) var customizations: ImageCustomizationDto
    
    convenience init() {
        self.init(url: nil, image: .init(), customizations: .init())
    }
    
    init(url: URL? = nil, image: NSImage, customizations: ImageCustomizationDto) {
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
    
    func updateCustomization(customizations: ImageCustomizationDto) async throws {
        
        self.customizations = customizations
                                        
        i256 = await customizations.update(image: o256)
        state = .preview
        progressValue = 10
        
        i128x2 = await customizations.update(image: o128x2)
        progressValue = 20
        
        i16 = await customizations.update(image: o16)
        progressValue = 25
        
        i16x2 = await customizations.update(image: o16x2)
        progressValue = 30
        
        i32 = await customizations.update(image: o32)
        progressValue = 40
        
        i32x2 = await customizations.update(image: o32x2)
        progressValue = 50
        
        i128 = await customizations.update(image: o128)
        progressValue = 60
        
        i128x2 = await customizations.update(image: o128x2)
        progressValue = 70
        
        i256x2 = await customizations.update(image: o256x2)
        progressValue = 80
        
        i512 = await customizations.update(image: o512)
        progressValue = 90
        
        i512x2 = await customizations.update(image: o512x2)
        progressValue = 100
        
        state = .ready
    }
    
    func updateOriginal(url: URL?, image: NSImage) async {
        
        self.url = url
        
        func imageFor(size: CGFloat, pixel: any BinaryInteger, in images: [NSImageRep]) -> NSImage {
            if let imageRep = images.first(where: { $0.size.width == size && $0.pixelsWide == pixel }), let cgImage = imageRep.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                return NSImage(cgImage: cgImage, size: .init(width: size, height: size))
            } else {
                assert(false, "wrong image for size: \(size), pixels: \(pixel)")
                return .init()
            }
        }
                        
        let images = image.representations
        
        o256 = imageFor(size: 256, pixel: 256, in: images)
        i256 = await customizations.update(image: o256)
        state = .preview
        progressValue = 10
        
        o128x2 = imageFor(size: 128, pixel: 256, in: images)
        i128x2 = await customizations.update(image: o128x2)
        progressValue = 20
        
        o16 = imageFor(size: 16, pixel: 16, in: images)
        i16 = await customizations.update(image: o16)
        progressValue = 25
        
        o16x2 = imageFor(size: 16, pixel: 32, in: images)
        i16x2 = await customizations.update(image: o16x2)
        progressValue = 30
        
        o32 = imageFor(size: 32, pixel: 32, in: images)
        i32 = await customizations.update(image: o32)
        progressValue = 40
        
        o32x2 = imageFor(size: 32, pixel: 64, in: images)
        i32x2 = await customizations.update(image: o32x2)
        progressValue = 50
        
        o128 = imageFor(size: 128, pixel: 128, in: images)
        i128 = await customizations.update(image: o128)
        progressValue = 60
        
        o128x2 = imageFor(size: 128, pixel: 256, in: images)
        i128x2 = await customizations.update(image: o128x2)
        progressValue = 70
        
        o256x2 = imageFor(size: 256, pixel: 512, in: images)
        i256x2 = await customizations.update(image: o256x2)
        progressValue = 80
        
        o512 = imageFor(size: 512, pixel: 512, in: images)
        i512 = await customizations.update(image: o512)
        progressValue = 90
        
        o512x2 = imageFor(size: 512, pixel: 1024, in: images)
        i512x2 = await customizations.update(image: o512x2)
        progressValue = 100
        
        state = .ready
    }
    
    @ViewBuilder
    var preview: some View {
        switch state {
        case .none:
            EmptyView()
        case .ready, .preview:
            Image(nsImage: i256)
                .resizable()
        case .processing(let progress):
            if progress < 20 {
                Image(nsImage: i256)
                    .resizable()
                    .blur(radius: 5.0)
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Image(nsImage: i256)
                    .resizable()
            }
        case .error:
            EmptyView()
        }
    }
}
