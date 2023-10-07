//
//  PictureItem.swift
//  colir
//
//  Created by Vitalii P on 07.10.2023.
//

import AppKit

struct PictureItem: Identifiable, Hashable {
    let id = UUID()
    
    let name: String
    
    let tags: [String]
    
    let image: NSImage
}
