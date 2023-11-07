//
//  ImageDto.swift
//  colir
//
//  Created by Vitalii P on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI

final class ImageDto: ObservableObject {
    
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
    
    @ViewBuilder
    var preview: some View {
        switch state {
        case .none:
            EmptyView()
        case .ready, .preview:
            Image(nsImage: o256)
                .resizable()
        case .processing:
            Image(nsImage: o256)
                .resizable()
            ProgressView()
                .progressViewStyle(.circular)
        case .error:
            EmptyView()
        }
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
    
    convenience init() {
        self.init(url: nil, image: .init())
    }
    
    init(url: URL? = nil, image: NSImage) {
        if image.isValid {
            Task {
                await updateOriginal(url: url, image: image)
            }
        }
    }
    
    func prepareForUpdate() {
        progressValue = 0
    }
    
    func updateOriginal(url: URL?, image: NSImage) async {
        
        let delay: useconds_t = 500000 //1000000 = 1s
        
        self.url = url
                
        let images = image.representations
        
        var size: CGFloat = 256
        if let image = images.first(where: { $0.size.width == size }) {
            o128x2 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
            o256 = o128x2
        } else {
            o128x2 = .init()
            o256 = .init()
        }
        i128x2 = o128x2
        i256 = o256
        state = .preview
        progressValue = 20
        
        usleep(delay)
        
        size = 16
        if let image = images.first(where: { $0.size.width == size }) {
            o16 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
        } else {
            o16 = .init()
        }
        i16 = o16
        progressValue = 30
        usleep(delay)
        
        size = 32
        if let image = images.first(where: { $0.size.width == size }) {
            o16x2 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
            o32 = o16x2
        } else {
            o16x2 = .init()
            o32 = .init()
        }
        i16x2 = o16x2
        i32 = o32
        progressValue = 40
        usleep(delay)
        
        size = 64
        if let image = images.first(where: { $0.size.width == size }) {
            o32x2 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
        } else {
            o32x2 = .init()
        }
        i32x2 = o32x2
        progressValue = 50
        usleep(delay)
        
        size = 128
        if let image = images.first(where: { $0.size.width == size }) {
            o128 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
        } else {
            o128 = .init()
        }
        i128 = o128
        progressValue = 60
        usleep(delay)
        
        size = 512
        if let image = images.first(where: { $0.size.width == size }) {
            o256x2 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
            o512 = o256x2
        } else {
            o256x2 = .init()
            o512 = .init()
        }
        i256x2 = o256x2
        i512 = o512
        
        progressValue = 80
        usleep(delay)
        
        size = 1024
        if let image = images.first(where: { $0.size.width == size }) {
            o512x2 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
        } else {
            o512x2 = .init()
        }
        i512x2 = o512x2
        
        progressValue = 100
        usleep(delay)
        
        state = .ready
        usleep(delay)
    }
}
