//
//  NSImage+Data.swift
//  colir
//
//  Created by Vitalii P on 05.05.2023.
//

import AppKit

extension NSBitmapImageRep {
    var pngData: Data? {
        representation(using: .png, properties: [:])
    }
}

extension Data {
    var bitmap: NSBitmapImageRep? {
        NSBitmapImageRep(data: self)
    }
}

extension NSImage {
    var pngData: Data? {
        tiffRepresentation?.bitmap?.pngData
    }
}
