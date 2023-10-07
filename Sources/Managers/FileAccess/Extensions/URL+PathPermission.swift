//
//  URL+PathPermission.swift
//  colir
//
//  Created by Vitalii P on 01.05.2023.
//

import Foundation

extension URL {
    var hasAccess: Bool {
        let fm = FileManager.default
        
        let _ = startAccessingSecurityScopedResource()
        let hasAccess = fm.isReadableFile(atPath: path) && fm.isWritableFile(atPath: path)
        stopAccessingSecurityScopedResource()
        
        return hasAccess
    }
}
