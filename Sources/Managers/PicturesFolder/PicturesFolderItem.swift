//
//  PicturesFolderItem.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//

import AppKit

struct PicturesFolderItem {
    let name: String
    
    let image: NSImage
    
    init?(name: String, image: NSImage?) {
        if let image {
            self.name = name
            self.image = image
        } else {
            return nil
        }
    }
}
