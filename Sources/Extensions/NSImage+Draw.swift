//
//  NSImage+Draw.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 08.11.2023.
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
    
    func draw(emoji: Character) -> NSImage {
        var fontScale: CGFloat = 1.8
        var xOffset: CGFloat = (24 * size.width / 512)
        var yScale = 4.6
        if size.width == 32 {
            fontScale = 2.2
            xOffset += 1
            yScale = 3.4
        } else if size.width == 16 {
            fontScale = 2.2
            yScale = 3
        }
        
        let font = NSFont.boldSystemFont(ofSize: size.height / fontScale)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: textStyle
            ]
        
        let img = NSImage(size: size)
        img.lockFocus()
        draw(in: CGRect(origin: .zero, size: size))
        String(emoji).draw(in: CGRect(origin: CGPoint(x: (size.width / 4) - xOffset, y: -(size.height / yScale)), size: size), withAttributes: textFontAttributes)
        
        img.unlockFocus()
        
        return img
    }
}
