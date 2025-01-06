//
//  URL+Dir.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 06.01.2025.
//  Copyright © 2025 IGR Software. All rights reserved.
//

import Foundation

public extension URL {
    
    /// Determines whether the URL represents a folder (directory).
    var isFolder: Bool {
        var isDir: ObjCBool = false
        
        FileManager.default.fileExists(atPath: self.path(percentEncoded: false), isDirectory: &isDir)
        
        return isDir.boolValue
    }
}
