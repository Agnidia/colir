//
//  ImageCustomizationDto.swift
//  colir
//
//  Created by Vitalii P on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

class ImageCustomizationDto {
    
    var selectedColor: NSColor? = nil
    
    var selectedImage: NSImage? = nil
    
    func update(image: NSImage) async -> NSImage {
        return image
    }
}
