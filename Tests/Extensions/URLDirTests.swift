//
//  URLDirTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Foundation
import Testing
@testable import colir

@Suite("URL Directory Extension")
struct URLDirTests {
    // MARK: - Setup/Teardown

    private func createTestDirectory() throws -> URL {
        let testDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("url-dir-tests-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        return testDir
    }

    private func cleanup(_ url: URL) {
        try? FileManager.default.removeItem(at: url)
    }

    // MARK: - Directory Detection Tests

    @Test("isFolder returns true for directory")
    func isFolder_returnsTrueForDirectory() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        #expect(testDir.isFolder == true)
    }

    @Test("isFolder returns false for file")
    func isFolder_returnsFalseForFile() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        let testFile = testDir.appendingPathComponent("test.txt")
        try "test content".write(to: testFile, atomically: true, encoding: .utf8)

        #expect(testFile.isFolder == false)
    }

    @Test("isFolder returns false for nonexistent path")
    func isFolder_returnsFalseForNonexistent() {
        let nonexistentURL = URL(fileURLWithPath: "/nonexistent/path/\(UUID().uuidString)")
        #expect(nonexistentURL.isFolder == false)
    }

    // MARK: - System Directory Tests

    @Test("isFolder recognizes system directories")
    func isFolder_systemDirectories() {
        let tempDir = FileManager.default.temporaryDirectory
        #expect(tempDir.isFolder == true)

        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        #expect(homeDir.isFolder == true)
    }

    // MARK: - Nested Directory Tests

    @Test("isFolder works for nested directories")
    func isFolder_nestedDirectories() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        let nestedDir = testDir.appendingPathComponent("level1/level2/level3")
        try FileManager.default.createDirectory(at: nestedDir, withIntermediateDirectories: true)

        #expect(nestedDir.isFolder == true)
        #expect(testDir.appendingPathComponent("level1").isFolder == true)
        #expect(testDir.appendingPathComponent("level1/level2").isFolder == true)
    }

    // MARK: - File Type Tests

    @Test("isFolder returns false for various file types")
    func isFolder_variousFileTypes() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        // Text file
        let txtFile = testDir.appendingPathComponent("test.txt")
        try "content".write(to: txtFile, atomically: true, encoding: .utf8)
        #expect(txtFile.isFolder == false)

        // Binary file
        let binFile = testDir.appendingPathComponent("test.bin")
        try Data([0x00, 0x01, 0x02]).write(to: binFile)
        #expect(binFile.isFolder == false)

        // Hidden file
        let hiddenFile = testDir.appendingPathComponent(".hidden")
        try "hidden".write(to: hiddenFile, atomically: true, encoding: .utf8)
        #expect(hiddenFile.isFolder == false)
    }

    // MARK: - Special Cases

    @Test("isFolder handles empty directory")
    func isFolder_emptyDirectory() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        let emptyDir = testDir.appendingPathComponent("empty")
        try FileManager.default.createDirectory(at: emptyDir, withIntermediateDirectories: true)

        #expect(emptyDir.isFolder == true)
    }

    @Test("isFolder handles directory with contents")
    func isFolder_directoryWithContents() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        let contentDir = testDir.appendingPathComponent("with-contents")
        try FileManager.default.createDirectory(at: contentDir, withIntermediateDirectories: true)

        // Add some files
        for i in 1 ... 5 {
            let file = contentDir.appendingPathComponent("file\(i).txt")
            try "content \(i)".write(to: file, atomically: true, encoding: .utf8)
        }

        #expect(contentDir.isFolder == true)
    }

    // MARK: - Path Encoding Tests

    @Test("isFolder handles spaces in path")
    func isFolder_spacesInPath() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        let spacedDir = testDir.appendingPathComponent("path with spaces")
        try FileManager.default.createDirectory(at: spacedDir, withIntermediateDirectories: true)

        #expect(spacedDir.isFolder == true)
    }

    @Test("isFolder handles unicode in path")
    func isFolder_unicodeInPath() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        let unicodeDir = testDir.appendingPathComponent("folder-\u{1F600}-\u{1F389}")
        try FileManager.default.createDirectory(at: unicodeDir, withIntermediateDirectories: true)

        #expect(unicodeDir.isFolder == true)
    }

    @Test("isFolder handles special characters in path")
    func isFolder_specialCharactersInPath() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        let specialDir = testDir.appendingPathComponent("folder-with-special_chars.and.dots")
        try FileManager.default.createDirectory(at: specialDir, withIntermediateDirectories: true)

        #expect(specialDir.isFolder == true)
    }

    // MARK: - Symlink Tests

    @Test("isFolder handles symlink to directory")
    func isFolder_symlinkToDirectory() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        let realDir = testDir.appendingPathComponent("real-dir")
        try FileManager.default.createDirectory(at: realDir, withIntermediateDirectories: true)

        let symlinkDir = testDir.appendingPathComponent("symlink-dir")
        try FileManager.default.createSymbolicLink(at: symlinkDir, withDestinationURL: realDir)

        // Symlink to directory should be considered a folder
        #expect(symlinkDir.isFolder == true)
    }

    @Test("isFolder handles symlink to file")
    func isFolder_symlinkToFile() throws {
        let testDir = try createTestDirectory()
        defer { cleanup(testDir) }

        let realFile = testDir.appendingPathComponent("real-file.txt")
        try "content".write(to: realFile, atomically: true, encoding: .utf8)

        let symlinkFile = testDir.appendingPathComponent("symlink-file")
        try FileManager.default.createSymbolicLink(at: symlinkFile, withDestinationURL: realFile)

        // Symlink to file should not be considered a folder
        #expect(symlinkFile.isFolder == false)
    }
}
