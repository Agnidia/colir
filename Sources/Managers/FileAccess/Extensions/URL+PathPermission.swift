//
//  URL+PathPermission.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 01.05.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

extension URL {
    /// Checks if the URL has access permissions for both reading and writing.
    /// - Returns: A Boolean value indicating whether the URL has both read and write access.
    var hasAccess: Bool {
        let fm = FileManager.default

        // Start accessing the resource with security scope.
        let _ = startAccessingSecurityScopedResource()

        // Check if the URL is readable and writable.
        let hasAccess = fm.isReadableFile(atPath: path) && fm.isWritableFile(atPath: path)

        // Stop accessing the resource with security scope.
        stopAccessingSecurityScopedResource()

        return hasAccess
    }
}
