//
//  String+Emoji.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.09.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
import AppKit

extension Character {
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else {
            return false
        }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var containsEmoji: Bool {
        contains(where: { $0.isEmoji })
    }
}

extension Character {
    private static let refUnicodeSize: CGFloat = 8
    private static let refUnicodePng = Character("\u{1fff}").png(ofSize: Character.refUnicodeSize)
    
    func png(ofSize fontSize: CGFloat) -> Data? {
        let attributes = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: fontSize)]
        let charStr = "\(self)" as NSString
        let size = charStr.size(withAttributes: attributes)
        
        let img = NSImage(size: size, flipped: false) { dstRect in
            charStr.draw(at: CGPoint(x: 0,y :0), withAttributes: attributes)
            return true
        }
        
        return img.tiffRepresentation
    }
    
    func unicodeAvailable() -> Bool {
        if let refUnicodePng = Character.refUnicodePng, let myPng = self.png(ofSize: Character.refUnicodeSize) {
            return refUnicodePng != myPng
        }
        
        return false
    }
}
