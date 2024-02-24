//
//  NSColor+Hex.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 24.02.2024.
//  Copyright © 2024 IGR Software. All rights reserved.
//

import AppKit

extension NSColor {
    
    var hexString: String {
        
        guard let rgbColor = usingType(.componentBased) else {
            return "FFFFFF"
        }
        let red = Int(round(rgbColor.redComponent * 0xFF))
        let green = Int(round(rgbColor.greenComponent * 0xFF))
        let blue = Int(round(rgbColor.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }
    
}
