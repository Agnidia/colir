//
//  FileAccessManagerTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("FileAccessManager Tests")
struct FileAccessManagerTests {
    // MARK: - FileAccessManagerError Tests

    @Test("FileAccessManagerError has expected cases")
    func error_hasCases() {
        // Verify all error cases exist
        _ = FileAccessManagerError.bookmarkDataNotCreated
        _ = FileAccessManagerError.userNotGivenAccess
        _ = FileAccessManagerError.userCancelled
        _ = FileAccessManagerError.sandboxAccessError

        #expect(true)
    }

    @Test("FileAccessManagerError conforms to Error")
    func error_conformsToError() {
        let error: Error = FileAccessManagerError.bookmarkDataNotCreated

        #expect(error is FileAccessManagerError)
    }

    @Test("FileAccessManagerError cases are distinct")
    func error_casesAreDistinct() {
        let error1 = FileAccessManagerError.bookmarkDataNotCreated
        let error2 = FileAccessManagerError.userNotGivenAccess

        // Verify they are different errors using string comparison
        let desc1 = String(describing: error1)
        let desc2 = String(describing: error2)
        #expect(desc1 != desc2)
    }

    // MARK: - FileAccessData Tests

    @Test("FileAccessData stores path and bookmark")
    func fileAccessData_storesValues() {
        let path = URL(fileURLWithPath: "/tmp/test")
        let bookmark = Data([1, 2, 3, 4])
        let accessData = FileAccessData(path: path, bookmark: bookmark)

        #expect(accessData.path == path)
        #expect(accessData.bookmark == bookmark)
    }

    @Test("FileAccessData with empty bookmark")
    func fileAccessData_emptyBookmark() {
        let path = URL(fileURLWithPath: "/tmp/test")
        let accessData = FileAccessData(path: path, bookmark: Data())

        #expect(accessData.path == path)
        #expect(accessData.bookmark.isEmpty)
    }

    @Test("FileAccessData path components accessible")
    func fileAccessData_pathComponents() {
        let path = URL(fileURLWithPath: "/Users/test/Pictures")
        let accessData = FileAccessData(path: path, bookmark: Data())

        #expect(accessData.path.lastPathComponent == "Pictures")
        #expect(accessData.path.pathExtension == "")
    }

    // MARK: - FileAccessManager Initialization Tests

    @Test("FileAccessManager initializes with path and bookmark")
    func init_withPathAndBookmark() {
        let path = URL(fileURLWithPath: "/tmp/test")
        let bookmark = Data([1, 2, 3])
        let manager = FileAccessManager(with: path, bookmarkData: bookmark)

        // Manager should be created successfully
        #expect(manager is FileAccessManagerProtocol)
    }

    @Test("FileAccessManager initializes with empty bookmark")
    func init_emptyBookmark() {
        let path = URL(fileURLWithPath: "/tmp/test")
        let manager = FileAccessManager(with: path, bookmarkData: Data())

        #expect(manager is FileAccessManagerProtocol)
    }

    // MARK: - Protocol Conformance Tests

    @Test("FileAccessManager conforms to protocol")
    func conformsToProtocol() {
        let path = URL(fileURLWithPath: "/tmp/test")
        let manager: FileAccessManagerProtocol = FileAccessManager(with: path, bookmarkData: Data())

        #expect(manager is FileAccessManager)
    }

    // MARK: - URL+PathPermission Extension Tests

    @Test("hasAccess returns false for nonexistent path")
    func hasAccess_nonexistentPath() {
        let nonexistentURL = URL(fileURLWithPath: "/nonexistent/path/\(UUID().uuidString)")

        #expect(!nonexistentURL.hasAccess)
    }

    @Test("hasAccess returns true for accessible temp directory")
    func hasAccess_tempDirectory() {
        let tempDir = FileManager.default.temporaryDirectory

        // Temp directory should be accessible
        #expect(tempDir.hasAccess == true)
    }

    @Test("hasAccess checks both read and write")
    func hasAccess_checksReadWrite() {
        // Create a temp file to test
        let tempFile = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".txt")

        try? "test".write(to: tempFile, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: tempFile) }

        // File should be accessible
        let hasAccess = tempFile.hasAccess
        #expect(hasAccess == true)
    }
}
