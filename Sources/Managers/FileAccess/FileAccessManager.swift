//
//  FileAccessManager.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 30.04.2023.
//

import Foundation
import AppKit

enum FileAccessManagerError: Error {
    case bookmarkDataNotCreated
    case userNotGivenAccess
    case sandboxAccessError
}

protocol FileAccessManagerProtocol {
    init(with path: URL, bookmarkData: Data)
    
    func checkAndSetupDataAccessIfNeeded() throws -> FileAccessData
}

struct FileAccessData {
    let path: URL
    let bookmark: Data
}

class FileAccessManager: FileAccessManagerProtocol {
    
    private enum K {
        static let promptMessage = "Choose ~/Pictures directory"
    }
    
    /// bookmarkData to restore access to user Pictures data directory
    private var bookmarkData: Data
    
    /// initiated path
    private var path: URL
    
    required init(with path: URL, bookmarkData: Data) {
        self.bookmarkData = bookmarkData
        self.path = path
    }
    
    func checkAndSetupDataAccessIfNeeded() throws -> FileAccessData {
        var accessData: FileAccessData!
        do {
            if bookmarkData.isEmpty == false, let data = try restoreAccess(for: path, bookmarkData: bookmarkData) {
                accessData = data
            } else {
                if let path = promptPermission(to: path) {
                    if let bookmarkData = try? path.bookmarkData(options: [.withSecurityScope]) {
                        accessData = FileAccessData(path: path, bookmark: bookmarkData)
                    } else {
                        throw FileAccessManagerError.bookmarkDataNotCreated
                    }
                } else {
                    throw FileAccessManagerError.userNotGivenAccess
                }
            }
        }
        
        return accessData
    }
    
    private func promptPermission(to dir: URL) -> URL? {
        NSOpenPanel.promptPermission(to: dir, message: K.promptMessage)
    }
    
    private func restoreAccess(for path: URL, bookmarkData: Data) throws -> FileAccessData? {
        var accessData: FileAccessData?
                
        if !path.hasAccess {
            do {
                var isBookmarkStale = false
                let bookmarkedUrl = try URL(resolvingBookmarkData: bookmarkData, options: [.withSecurityScope], bookmarkDataIsStale: &isBookmarkStale)
                
                if !isBookmarkStale {
                    if bookmarkedUrl.hasAccess {
                        accessData = FileAccessData(path: bookmarkedUrl, bookmark: bookmarkData)
                    } else {
                        throw FileAccessManagerError.sandboxAccessError
                    }
                } else {
                    // macOS invalidated access need refresh bookmark.
                    if let bookmarkData = try? path.bookmarkData(options: [.withSecurityScope]) {
                        accessData = FileAccessData(path: bookmarkedUrl, bookmark: bookmarkData)
                    } else {
                        throw FileAccessManagerError.bookmarkDataNotCreated
                    }
                }
            }
        } else {
            accessData = FileAccessData(path: path, bookmark: bookmarkData)
        }
        
        return accessData
    }
}
