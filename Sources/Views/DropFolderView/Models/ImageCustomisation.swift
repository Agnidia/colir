//
//  ImageCustomization.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import DominantColor

/// A data transfer object for storing the state of image customizations for undo functionality.
struct ImageCustomisationUndoDto {
    let selectedColor: NSColor?
    let selectedPicture: NSImage?
    let selectedAsset: PhotoAsset?
    let selectedPictureItem: PictureItem?
    let selectedEmoji: Character?
    
    init(selectedColor: NSColor? = nil, selectedPicture: NSImage? = nil, selectedAsset: PhotoAsset? = nil, selectedPictureItem: PictureItem? = nil, selectedEmoji: Character? = nil) {
        self.selectedColor = selectedColor
        self.selectedPicture = selectedPicture
        self.selectedAsset = selectedAsset
        self.selectedPictureItem = selectedPictureItem
        self.selectedEmoji = selectedEmoji
    }
}

final class ImageCustomisation {
    
    /// Represents the different states an image can be in during customization.
    enum ImageState {
        case empty
        case dirty
        case processed
    }
    
    private static var dummyImages: [ImageDto.ImageSize: ImageState] {
        ImageDto.ImageSize.allCases.reduce([ImageDto.ImageSize: ImageState]()) {
            var result = $0
            result[$1] = .empty
            return result
        }
    }
    
    private var coloredImageState: [ImageDto.ImageSize: ImageState] = dummyImages
    private(set) var selectedColor: NSColor? = nil
    
    private let folderLines = NSImage(resource: .imgFolderLines)
    private let folderBottomShadow = NSImage(resource: .imgFolderBottomShadow)
    
    private var picturedImageState: [ImageDto.ImageSize: ImageState] = dummyImages
    private(set) var selectedPicture: NSImage? = nil
    private(set) var selectedAsset: PhotoAsset? = nil
    private(set) var selectedPictureItem: PictureItem? = nil
    
    private var emojiedImageState: [ImageDto.ImageSize: ImageState] = dummyImages
    private(set) var selectedEmoji: Character? = nil
    
    /// Returns the current state of customizations for undo functionality.
    var undoItems: ImageCustomisationUndoDto {
        .init(selectedColor: selectedColor, selectedPicture: selectedPicture, selectedAsset: selectedAsset, selectedPictureItem: selectedPictureItem, selectedEmoji: selectedEmoji)
    }
    
    /// Updates the customization properties from the provided undo item.
    ///
    /// - Parameter undoItem: The undo data to apply.
    func update(from undoItem: ImageCustomisationUndoDto) {
        selectedColor = undoItem.selectedColor
        selectedPicture = undoItem.selectedPicture
        selectedEmoji = undoItem.selectedEmoji
    }
    
    /// Applies a color to the image customizations.
    ///
    /// - Parameter color: The color to apply.
    func apply(color: NSColor?) async {
        selectedColor = color
        
        let newState: ImageState = color != nil ? .dirty : .empty
        
        coloredImageState.keys.forEach { coloredImageState[$0] = newState }
        picturedImageState.keys.forEach { picturedImageState[$0] = .dirty }
        emojiedImageState.keys.forEach { emojiedImageState[$0] = .dirty }
    }
    
    /// Updates the color of the image based on the selected color.
    ///
    /// - Parameters:
    ///   - image: The original image to be updated.
    ///   - size: The size of the image being processed.
    ///   - updatedImage: The previously updated image.
    /// - Returns: The updated image with the applied color.
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
    
    /// Applies a picture, asset, and item to the image customizations.
    ///
    /// - Parameters:
    ///   - picture: The picture to apply.
    ///   - asset: An optional photo asset to associate with the picture.
    ///   - item: An optional picture item to associate with the picture.
    func apply(picture: NSImage?, asset: PhotoAsset? = nil, item: PictureItem? = nil) async {
        selectedPicture = picture
        selectedAsset = asset
        selectedPictureItem = item
        
        let newState: ImageState = picture != nil ? .dirty : .empty
        
        picturedImageState.keys.forEach { picturedImageState[$0] = newState }
        emojiedImageState.keys.forEach { emojiedImageState[$0] = .dirty }
    }
    
    /// Updates the picture of the image based on the selected picture.
    ///
    /// - Parameters:
    ///   - image: The original image to be updated.
    ///   - size: The size of the image being processed.
    ///   - updatedImage: The previously updated image.
    /// - Returns: The updated image with the applied picture.
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
            
            let shadow = folderBottomShadow.scaled(to: scaleSize)
            newImage = update(image: newImage, with: shadow)
            
            return newImage
        case .processed:
            return updatedImage
        case .none:
            return image
        }
    }
    
    /// Applies an emoji to the image customizations.
    ///
    /// - Parameter emoji: The emoji to apply.
    func apply(emoji: Character?) async {
        selectedEmoji = emoji
        
        let newState: ImageState = emoji != nil ? .dirty : .empty
        emojiedImageState.keys.forEach { emojiedImageState[$0] = newState }
    }
    
    /// Updates the image with the selected emoji.
    ///
    /// - Parameters:
    ///   - image: The original image to be updated.
    ///   - size: The size of the image being processed.
    ///   - updatedImage: The previously updated image.
    /// - Returns: The updated image with the applied emoji.
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
    
    /// Applies a color tint to the image.
    ///
    /// - Parameters:
    ///   - color: The color to apply.
    ///   - image: The original image to be updated.
    /// - Returns: The image with the applied color tint.
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
    
    /// Draws an image on top of another image.
    ///
    /// - Parameters:
    ///   - image: The original image.
    ///   - img: The image to draw on top.
    /// - Returns: The combined image.
    private func update(image: NSImage, with img: NSImage) -> NSImage {
        var point: CGPoint = .zero
        
        // Adjust offset for small images
        if img.size.width < 255 {
            point = .init(x: .zero, y: -1)
        }
        
        return image.draw(image: img, at: point)
    }
    
    /// Draws an emoji on top of an image.
    ///
    /// - Parameters:
    ///   - image: The original image.
    ///   - emoji: The emoji to draw.
    /// - Returns: The image with the applied emoji.
    private func update(image: NSImage, with emoji: Character) -> NSImage {
        // TODO: Add logic for drawing emoji
        return image.draw(emoji: emoji)
    }
}
