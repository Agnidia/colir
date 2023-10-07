//
//  URL+Icon.swift
//  colir
//
//  Created by Vitalii P on 31.08.2023.
//

import Foundation
import AppKit

extension URL {
    var icon: NSImage? {
        
        let workspace = NSWorkspace.shared
        
        let icon = workspace.icon(forFile: path())
                
        // icon for folder without icon
        let emptyIcon = workspace.icon(for: .item)
        
        // return default icon of folder
        if icon.tiffRepresentation == emptyIcon.tiffRepresentation {
            return workspace.icon(for: .folder)
        }
        
        return icon
    }
}
