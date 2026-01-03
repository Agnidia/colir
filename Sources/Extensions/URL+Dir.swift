//
//  URL+Dir.swift
//
//  Created on 06.01.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import Foundation

extension URL {
    /// Determines whether the URL represents a folder (directory).
    public var isFolder: Bool {
        var isDir: ObjCBool = false

        FileManager.default.fileExists(atPath: path(percentEncoded: false), isDirectory: &isDir)

        return isDir.boolValue
    }
}
