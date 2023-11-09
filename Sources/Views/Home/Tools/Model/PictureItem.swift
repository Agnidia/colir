//
//  PictureItem.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//

import AppKit

struct PictureItem: Identifiable, Hashable {
    let id = UUID()
    
    let name: String
    
    let tags: [String]
    
    let image: NSImage
}

extension PictureItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.tags == rhs.tags
    }
}
