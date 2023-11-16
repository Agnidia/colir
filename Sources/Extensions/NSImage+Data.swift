//
//  NSImage+Data.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 05.05.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
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
