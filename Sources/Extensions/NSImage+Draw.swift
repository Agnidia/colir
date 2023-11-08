//
//  NSImage+Draw.swift
//  colir
//
//  Created by Vitalii P on 08.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension NSImage {
    func draw(image: NSImage, at position: CGPoint = .zero) -> NSImage {
        
        let img = NSImage(size: size)
        img.lockFocus()
        draw(in: CGRect(origin: .zero, size: size))
        image.draw(in: CGRect(origin: position, size: size))
        
        img.unlockFocus()
        
        return img
    }
}
