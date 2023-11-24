//
//  RGBA32.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 05.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

public struct RGBA32: Equatable, Hashable {
    private var color: UInt32
    
    var redComponent: UInt8 {
        return UInt8((color >> 24) & 255)
    }
    
    var greenComponent: UInt8 {
        return UInt8((color >> 16) & 255)
    }
    
    var blueComponent: UInt8 {
        return UInt8((color >> 8) & 255)
    }
    
    var alphaComponent: UInt8 {
        return UInt8((color >> 0) & 255)
    }
    
    init(color: NSColor) {
        var red:   CGFloat = .zero
        var green: CGFloat = .zero
        var blue:  CGFloat = .zero
        var alpha: CGFloat = .zero
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.color = (UInt32(red * 255) << 24) | (UInt32(green * 255) << 16) | (UInt32(blue * 255) << 8) | (UInt32(alpha * 255) << 0)
    }
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let red   = UInt32(red)
        let green = UInt32(green)
        let blue  = UInt32(blue)
        let alpha = UInt32(alpha)
        color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
    }
    
    func colors(tolerance: UInt8) -> (RGBA32, RGBA32) {
        let red   = redComponent
        let green = greenComponent
        let blue  = blueComponent
        let alpha = alphaComponent
        
        let redMin   = red   < tolerance ? 0 : red   - tolerance
        let greenMin = green < tolerance ? 0 : green - tolerance
        let blueMin  = blue  < tolerance ? 0 : blue  - tolerance
        let alphaMin = alpha < tolerance ? 0 : alpha - tolerance
        
        let redMax   = red   > (255 - tolerance) ? 255 : red   + tolerance
        let greenMax = green > (255 - tolerance) ? 255 : green + tolerance
        let blueMax  = blue  > (255 - tolerance) ? 255 : blue  + tolerance
        let alphaMax = alpha > (255 - tolerance) ? 255 : alpha + tolerance
        
        return (RGBA32(red: redMin, green: greenMin, blue: blueMin, alpha: alphaMin),
                RGBA32(red: redMax, green: greenMax, blue: blueMax, alpha: alphaMax))
    }
    
    func between(_ min: RGBA32, _ max: RGBA32) -> Bool {
        redComponent   >= min.redComponent   && redComponent   <= max.redComponent &&
        greenComponent >= min.greenComponent && greenComponent <= max.greenComponent &&
        blueComponent  >= min.blueComponent  && blueComponent  <= max.blueComponent
    }
    
    func colorDiff(otherColor: RGBA32) -> UInt8 {
        let r = pow(Double(redComponent) - Double(otherColor.redComponent), 2)
        let g = pow(Double(greenComponent) - Double(otherColor.greenComponent), 2)
        let b = pow(Double(blueComponent) - Double(otherColor.blueComponent), 2)
        let result = min(sqrt(r + g + b), 255)
        
        return UInt8(result)
    }
    
    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
}

