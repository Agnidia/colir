//
//  PicturesFolderItem.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
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

extension PicturesFolderItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}
