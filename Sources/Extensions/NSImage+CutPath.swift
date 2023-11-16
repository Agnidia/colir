//
//  NSImage+CutPath.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 08.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension NSImage {
    
    func cutImage(by path: NSBezierPath) -> NSImage {
        let size = size
        
        // Create an NSImage of the same size as the original image
        let cutImage = NSImage(size: size)
        
        // Begin drawing in the cutImage
        cutImage.lockFocus()
        
        // Create a clipping path using NSBezierPath
        let clippingPath = path
        clippingPath.windingRule = .evenOdd
        
        // Add the clipping path to the graphics context
        clippingPath.addClip()
        
        // Draw the original image into the cutImage
        draw(in: NSRect(origin: .zero, size: size))
        
        // End drawing in the cutImage
        cutImage.unlockFocus()
        
        return cutImage
    }
}
