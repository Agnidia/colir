//
//  ImageCustomizationDto.swift
//  colir
//
//  Created by Vitalii P on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import DominantColor

class ImageCustomizationDto {
    
    var selectedColor: NSColor? = nil
    
    private let folderLines = NSImage(resource: .imgFolderLines)
    private let folderBottomShadow = NSImage(resource: .imgFolderBottomShadow)
    
    var selectedImage: NSImage? = nil
    
    func update(image: NSImage) async -> NSImage {
        var newImage = image
        
        if let color = selectedColor {
            newImage = update(color: color, for: image)
        }
        
        if let img = selectedImage?.scaled(to: image.size) {
            newImage = update(image: newImage, with: img)
            
            let lines = folderLines.scaled(to: image.size)
            newImage = update(image: newImage, with: lines)
            
            let shadow = folderLines.scaled(to: image.size)
            newImage = update(image: newImage, with: shadow)
        }
        
        return newImage
    }
    
    private func update(color: NSColor, for image: NSImage) -> NSImage {
        
        let dominantColors = image.dominantColors()
        guard let mainColor = dominantColors.first else {
            return image
        }
        
        guard let newImage = image.tint(color: mainColor, withColor: color, tolerance: 0.6) else {
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
}
