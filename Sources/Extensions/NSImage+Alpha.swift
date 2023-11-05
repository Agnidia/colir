//
//  NSImage+Tint.swift
//  ColorFolder
//
//  Created by Vitalii P on 05.05.2023.
//

import AppKit

public extension NSImage {
    //TODO: create icns from images
    func alpha(_ value: CGFloat) throws -> NSImage {
        
        var icons = [NSImage]()
        for icon in representations {
            let iconSize = icon.size
            
            let newImage = NSImage(cgImage: icon.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: iconSize)
            
            let img = newImage.alpha(value: UInt8(value * 255))!
            
            icons.append(img)
        }
        
        return try NSImage(data: IconManager().convertImagesToIcns(icons))!
    }
    
    // alpha - source color, which is must be replaced
    // value - value in range from 0 to 255
    func alpha(value: UInt8) -> NSImage? {
        guard let imageRef = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        /// Graphics context parameters
        
        let bitsPerComponent = 8
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = RGBA32.bitmapInfo
        let width = imageRef.width
        let height = imageRef.height
        
        // back image
        
        let backImageBytesPerRow = width * 4
        let backImagePixelCount = width * height
        let contextBackImage = CGContext(data: nil,
                                         width: width,
                                         height: height,
                                         bitsPerComponent: bitsPerComponent,
                                         bytesPerRow: backImageBytesPerRow,
                                         space: colorspace,
                                         bitmapInfo: bitmapInfo)
        
        guard let dataBackImage = contextBackImage?.data else {
            print("replaceColor: Unable to get back image buffer")
            return nil
        }
        let bufferBackImage = dataBackImage.bindMemory(to: RGBA32.self, capacity: width * height)
        contextBackImage!.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // front image
        
        // Prepare to iterate over image pixels
        
        for offset in 0..<backImagePixelCount {
            let color = bufferBackImage[offset]
            
            bufferBackImage[offset] = RGBA32(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: UInt8(Float(color.alphaComponent) * Float(value) / 255) )
        }
        
        // Retrieve image from memory context
        
        let img = CGContext(data: bufferBackImage,
                            width: width,
                            height: height,
                            bitsPerComponent: bitsPerComponent,
                            bytesPerRow: backImageBytesPerRow,
                            space: colorspace,
                            bitmapInfo: bitmapInfo)
        
        let finalImage = NSImage(cgImage: (img?.makeImage()!)!, size: .init(width: width, height: height))
        return finalImage
    }
}
