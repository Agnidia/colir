//
//  DropFolderViewConstants.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

enum DropFolderViewConstants {
    static var icon: NSImage {
        let image = NSImage(systemSymbolName: "folder.badge.plus", accessibilityDescription: nil)!
        var config = NSImage.SymbolConfiguration(textStyle: .body, scale: .large)
        config = config.applying(.init(paletteColors: [.systemGreen, .systemGray]))
        return (image.withSymbolConfiguration(config))!
    }
}
