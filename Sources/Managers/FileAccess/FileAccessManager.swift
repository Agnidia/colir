//
//  FileAccessManager.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 30.04.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
import AppKit

enum FileAccessManagerError: Error {
    case bookmarkDataNotCreated
    case userNotGivenAccess
    case sandboxAccessError
}

/// A protocol defining methods for managing file access with security scopes and bookmarks.
protocol FileAccessManagerProtocol {
    init(with path: URL, bookmarkData: Data)
    
    @MainActor func checkAndSetupDataAccessIfNeeded() throws -> FileAccessData
}

/// A struct representing the data needed for file access, including a URL and its associated bookmark data.
struct FileAccessData {
    let path: URL
    let bookmark: Data
}

/// A manager class for handling file access by using bookmarks and security scopes.
final class FileAccessManager: FileAccessManagerProtocol {
    
    private enum K {
        static let promptMessage = "Choose ~/Pictures directory"
    }
    
    /// Bookmark data used to restore access to a specific directory.
    private var bookmarkData: Data
    
    /// The path to the directory for which access is managed.
    private var path: URL
    
    /// Initializes a `FileAccessManager` with a directory path and associated bookmark data.
    /// - Parameters:
    ///   - path: The URL of the directory for which access is managed.
    ///   - bookmarkData: The bookmark data for the directory.
    required init(with path: URL, bookmarkData: Data) {
        self.bookmarkData = bookmarkData
        self.path = path
    }
    
    /// Checks and sets up data access if needed.
    /// - Throws: Throws an error if access cannot be established.
    /// - Returns: The `FileAccessData` containing the path and bookmark data if access is granted.
    @MainActor
    func checkAndSetupDataAccessIfNeeded() throws -> FileAccessData {
        var accessData: FileAccessData!
        do {
            if !bookmarkData.isEmpty, let data = try restoreAccess(for: path, bookmarkData: bookmarkData) {
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
    
    /// Prompts the user to grant access to a specific directory.
    /// - Parameters:
    ///   - dir: The URL of the directory to prompt for access.
    /// - Returns: The URL of the directory if access is granted; otherwise, `nil`.
    @MainActor
    private func promptPermission(to dir: URL) -> URL? {
        NSOpenPanel.promptPermission(to: dir, message: K.promptMessage)
    }
    
    /// Restores access to a directory using a bookmark.
    /// - Parameters:
    ///   - path: The URL of the directory.
    ///   - bookmarkData: The bookmark data for the directory.
    /// - Throws: Throws an error if the bookmark data cannot be resolved or is stale.
    /// - Returns: The `FileAccessData` if access is restored successfully; otherwise, `nil`.
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
                    // macOS invalidated access; need to refresh the bookmark.
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
