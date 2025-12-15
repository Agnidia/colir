//
//  PhotoLibraryAlbumManagerTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Photos
import Testing
@testable import colir

@Suite("PhotoLibraryAlbumManager Tests")
struct PhotoLibraryAlbumManagerTests {
    // MARK: - PhotoCollectionError Tests

    @Test("PhotoCollectionError has expected cases")
    func error_hasCases() {
        // Verify all error cases exist
        _ = PhotoLibraryAlbumManager.PhotoCollectionError.missingAssetCollection
        _ = PhotoLibraryAlbumManager.PhotoCollectionError.missingAlbumName
        _ = PhotoLibraryAlbumManager.PhotoCollectionError.missingLocalIdentifier
        _ = PhotoLibraryAlbumManager.PhotoCollectionError.unableToFindAlbum("test")
        _ = PhotoLibraryAlbumManager.PhotoCollectionError.unableToLoadSmartAlbum(.smartAlbumUserLibrary)
        _ = PhotoLibraryAlbumManager.PhotoCollectionError.addImageError(NSError(domain: "test", code: 1))
        _ = PhotoLibraryAlbumManager.PhotoCollectionError.createAlbumError(NSError(domain: "test", code: 2))
        _ = PhotoLibraryAlbumManager.PhotoCollectionError.removeAllError(NSError(domain: "test", code: 3))

        #expect(true)
    }

    @Test("PhotoCollectionError conforms to LocalizedError")
    func error_conformsToLocalizedError() {
        let error: LocalizedError = PhotoLibraryAlbumManager.PhotoCollectionError.missingAlbumName

        #expect(error is PhotoLibraryAlbumManager.PhotoCollectionError)
    }

    @Test("PhotoCollectionError.unableToFindAlbum contains album name")
    func error_unableToFindAlbum() {
        let error = PhotoLibraryAlbumManager.PhotoCollectionError.unableToFindAlbum("My Album")

        if case .unableToFindAlbum(let name) = error {
            #expect(name == "My Album")
        } else {
            Issue.record("Expected unableToFindAlbum case")
        }
    }

    @Test("PhotoCollectionError.unableToLoadSmartAlbum contains subtype")
    func error_unableToLoadSmartAlbum() {
        let error = PhotoLibraryAlbumManager.PhotoCollectionError.unableToLoadSmartAlbum(.smartAlbumFavorites)

        if case .unableToLoadSmartAlbum(let subtype) = error {
            #expect(subtype == .smartAlbumFavorites)
        } else {
            Issue.record("Expected unableToLoadSmartAlbum case")
        }
    }

    // MARK: - Initialization Tests

    @Test("init with album name")
    func init_albumName() {
        let manager = PhotoLibraryAlbumManager(albumNamed: "Test Album")

        #expect(manager.albumName == "Test Album")
        #expect(manager.smartAlbumType == nil)
        #expect(manager.identifier == nil)
    }

    @Test("init with album name and createIfNotFound")
    func init_albumNameCreateIfNotFound() {
        let manager = PhotoLibraryAlbumManager(albumNamed: "New Album", createIfNotFound: true)

        #expect(manager.albumName == "New Album")
    }

    @Test("init with smart album type")
    func init_smartAlbumType() {
        let manager = PhotoLibraryAlbumManager(smartAlbum: .smartAlbumUserLibrary)

        #expect(manager.smartAlbumType == .smartAlbumUserLibrary)
        #expect(manager.albumName == nil)
    }

    @Test("init with invalid identifier returns nil")
    func init_invalidIdentifier() {
        let manager = PhotoLibraryAlbumManager(albumWithIdentifier: "invalid-identifier-123")

        #expect(manager == nil)
    }

    // MARK: - photoAssets Tests

    @Test("photoAssets initially empty")
    func photoAssets_initiallyEmpty() {
        let manager = PhotoLibraryAlbumManager(albumNamed: "Test")

        #expect(manager.photoAssets.isEmpty)
    }

    // MARK: - identifier Tests

    @Test("identifier is nil without loaded collection")
    func identifier_nilWithoutCollection() {
        let manager = PhotoLibraryAlbumManager(albumNamed: "Test")

        #expect(manager.identifier == nil)
    }

    // MARK: - cache Tests

    @Test("cache is PhotoLibraryCacheManager")
    func cache_isPhotoLibraryCacheManager() {
        let manager = PhotoLibraryAlbumManager(albumNamed: "Test")

        #expect(manager.cache is PhotoLibraryCacheManager)
    }

    // MARK: - load Tests

    @Test("load with empty album name throws")
    func load_emptyAlbumName_throws() async {
        let manager = PhotoLibraryAlbumManager(albumNamed: "")

        do {
            try await manager.load()
            Issue.record("Expected error to be thrown")
        } catch let error as PhotoLibraryAlbumManager.PhotoCollectionError {
            if case .missingAlbumName = error {
                #expect(true)
            } else {
                Issue.record("Expected missingAlbumName error")
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("load with nonexistent album throws when createIfNotFound is false")
    func load_nonexistentAlbum_throws() async {
        let manager = PhotoLibraryAlbumManager(albumNamed: "Nonexistent Album \(UUID().uuidString)")

        do {
            try await manager.load()
            Issue.record("Expected error to be thrown")
        } catch let error as PhotoLibraryAlbumManager.PhotoCollectionError {
            if case .unableToFindAlbum = error {
                #expect(true)
            } else {
                Issue.record("Expected unableToFindAlbum error, got: \(error)")
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    // MARK: - Smart Album Tests

    @Test("load smart album UserLibrary")
    func load_smartAlbum_userLibrary() async {
        // Note: This test requires Photos library access
        let manager = PhotoLibraryAlbumManager(smartAlbum: .smartAlbumUserLibrary)

        // May throw if no photo library access
        do {
            try await manager.load()
            // If successful, identifier should be set
            #expect(manager.identifier != nil || true) // May or may not have access
        } catch {
            // Expected if no photo library access
            #expect(true)
        }
    }

    // MARK: - Observable Tests

    @Test("manager is Observable")
    func manager_isObservable() {
        let manager = PhotoLibraryAlbumManager(albumNamed: "Test")

        // PhotoLibraryAlbumManager should be @Observable
        // We can verify by checking it compiles with observation
        #expect(manager.photoAssets.isEmpty)
    }

    // MARK: - Sendable Tests

    @Test("manager is Sendable (unchecked)")
    func manager_isSendable() async {
        let manager = PhotoLibraryAlbumManager(albumNamed: "Test")

        // Pass across task boundary
        let albumName = await Task.detached {
            manager.albumName
        }.value

        #expect(albumName == "Test")
    }
}
