//
//  ImageDto.swift
//  colir
//
//  Created by Vitalii P on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

class ImageDto: ObservableObject {
    
    enum ImageState: Equatable {
        case none
        case ready
        case processing(value: Int)
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
    
    @Published var preview: NSImage = .init()
    
    var url: URL?
    
    var state: ImageState = .none
    
    var isValid: Bool {
        url != nil && state == .ready
    }
    
    convenience init() {
        let folderIcon: NSImage!
        let image: NSImage = NSWorkspace.shared.icon(for: .folder)
        do {
            folderIcon = try image.alpha(0.3)
        } catch {
            folderIcon = image
        }
        
        self.init(url: nil, image: folderIcon)
        
        self.state = .preview
    }
    
    init(url: URL? = nil, image: NSImage) {
        updateOriginal(url: url, image: image)
    }
    
    func updateOriginal(url: URL?, image: NSImage) {
        self.url = url
                
        let images = image.representations
        
        var size: CGFloat = 16
        if let image = images.first(where: { $0.size.width == size }) {
            o16 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
        } else {
            o16 = .init()
        }
        i16 = o16
        
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
        
        size = 64
        if let image = images.first(where: { $0.size.width == size }) {
            o32x2 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
        } else {
            o32x2 = .init()
        }
        i32x2 = o32x2
        
        size = 128
        if let image = images.first(where: { $0.size.width == size }) {
            o128 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
        } else {
            o128 = .init()
        }
        i128 = o128
        
        size = 256
        if let image = images.first(where: { $0.size.width == size }) {
            o128x2 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
            o256 = o128x2
        } else {
            o128x2 = .init()
            o256 = .init()
        }
        i128x2 = o128x2
        i256 = o256
        
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
        
        size = 1024
        if let image = images.first(where: { $0.size.width == size }) {
            o512x2 = NSImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: .init(width: size, height: size))
        } else {
            o512x2 = .init()
        }
        i512x2 = o512x2
        
        preview = i256
        
        state = .ready
    }
}
