//
//  URL+Dir.swift
//  colir
//
//  Created by Vitalii P on 31.08.2023.
//

import Foundation

extension URL {
    var isFolder: Bool {
        var isDir: ObjCBool = false
        
        FileManager.default.fileExists(atPath: self.path(), isDirectory: &isDir)
        
        return isDir.boolValue
    }
}
