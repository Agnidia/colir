//
//  ImageCustomization.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import DominantColor

struct ImageCustomizationUndoDto {
    let selectedColor: NSColor?
    let selectedPicture: NSImage?
    let selectedAsset: PhotoAsset?
    let selectedPictureItem: PictureItem?
    let selectedEmoji: String?
    
    init(selectedColor: NSColor? = nil, selectedPicture: NSImage? = nil, selectedAsset: PhotoAsset? = nil, selectedPictureItem: PictureItem? = nil, selectedEmoji: String? = nil) {
        self.selectedColor = selectedColor
        self.selectedPicture = selectedPicture
        self.selectedAsset = selectedAsset
        self.selectedPictureItem = selectedPictureItem
        self.selectedEmoji = selectedEmoji
    }
}

final class ImageCustomization {
    
    enum ImageState {
        case empty
        case dirty
        case processed
    }
    
    private static var dummyImages = ImageDto.ImageSize.allCases.reduce([ImageDto.ImageSize: ImageState]()) {
        var result = $0
        result[$1] = .empty
        return result
    }
    
    private var coloredImageState: [ImageDto.ImageSize: ImageState] = dummyImages
    private var selectedColor: NSColor? = nil
    
    private let folderLines = NSImage(resource: .imgFolderLines)
    private let folderBottomShadow = NSImage(resource: .imgFolderBottomShadow)
    
    private var picturedImageState: [ImageDto.ImageSize: ImageState] = dummyImages
    private var selectedPicture: NSImage? = nil
    private var selectedAsset: PhotoAsset? = nil
    private var selectedPictureItem: PictureItem? = nil
    
    private var emojiedImageState: [ImageDto.ImageSize: ImageState] = dummyImages
    private var selectedEmoji: String? = nil
    
    var undoItems: ImageCustomizationUndoDto {
        .init(selectedColor: selectedColor, selectedPicture: selectedPicture, selectedAsset: selectedAsset, selectedPictureItem: selectedPictureItem, selectedEmoji: selectedEmoji)
    }
    
    func update(from undoItem: ImageCustomizationUndoDto) {
        selectedColor = undoItem.selectedColor
        selectedPicture = undoItem.selectedPicture
        selectedEmoji = undoItem.selectedEmoji
    }
    
    func apply(color: NSColor?) async {
        selectedColor = color
        
        let newState: ImageState = color != nil ? .dirty : .empty
        
        coloredImageState.keys.forEach { coloredImageState[$0] = newState }
        picturedImageState.keys.forEach { picturedImageState[$0] = .dirty }
        emojiedImageState.keys.forEach { emojiedImageState[$0] = .dirty }
    }
    
    func updateColor(for image: NSImage, size: ImageDto.ImageSize, updatedImage: NSImage) async -> NSImage {
        switch coloredImageState[size] {
        case .empty:
            return image
        case .dirty:
            guard let color = selectedColor else { return image }
            coloredImageState[size] = .processed
            return update(color: color, for: image)
        case .processed:
            return updatedImage
        case .none:
            return image
        }
    }
    
    func apply(picture: NSImage?, asset: PhotoAsset? = nil, item: PictureItem? = nil) async {
        selectedPicture = picture
        selectedAsset = asset
        selectedPictureItem = item
        
        let newState: ImageState = picture != nil ? .dirty : .empty
        
        picturedImageState.keys.forEach { picturedImageState[$0] = newState }
        emojiedImageState.keys.forEach { emojiedImageState[$0] = .dirty }
    }
    
    func updatePicture(for image: NSImage, size: ImageDto.ImageSize, updatedImage: NSImage) async -> NSImage {
        switch picturedImageState[size] {
        case .empty:
            return image
        case .dirty:
            guard let picture = selectedPicture else { return image }
            picturedImageState[size] = .processed
            var newImage = image
            let scaleSize = CGSize(width: size.dimension, height: size.dimension)
            
            let img = picture.scaled(to: scaleSize)
            newImage = update(image: newImage, with: img)
            
            let lines = folderLines.scaled(to: scaleSize)
            newImage = update(image: newImage, with: lines)
            
            let shadow = folderLines.scaled(to: scaleSize)
            newImage = update(image: newImage, with: shadow)
            
            return newImage
        case .processed:
            return updatedImage
        case .none:
            return image
        }
    }
    
    func apply(emoji: String?) async {
        selectedEmoji = emoji
        
        let newState: ImageState = emoji != nil ? .dirty : .empty
        emojiedImageState.keys.forEach { emojiedImageState[$0] = newState }
    }
    
    func updateEmoji(for image: NSImage, size: ImageDto.ImageSize, updatedImage: NSImage) async -> NSImage {
        switch emojiedImageState[size] {
        case .empty:
            return image
        case .dirty:
            guard let emoji = selectedEmoji else { return image }
            emojiedImageState[size] = .processed
            return update(image: image, with: emoji)
        case .processed:
            return updatedImage
        case .none:
            return image
        }
    }
    
    private func update(color: NSColor, for image: NSImage) -> NSImage {
        
        let dominantColors = image.dominantColors()
        guard let mainColor = dominantColors.first else {
            return image
        }
        
        guard let newImage = image.tint(color: mainColor, withColor: color) else {
            return image
        }
        
        return newImage
    }
    
    private func update(image: NSImage, with img: NSImage) -> NSImage {
        var point: CGPoint = .zero
        
        // magic offset for small images
        if img.size.width < 255 {
            point = .init(x: .zero, y: -1)
        }
        
        return image.draw(image: img, at: point)
    }
    
    private func update(image: NSImage, with emoji: String) -> NSImage {
        //TODO: add logic
        
        return image
    }
}
