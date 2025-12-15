//
//  PhotoLibraryAlbumManager.swift
//
//  Created on 10.10.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Photos

/// Manages photo albums and photo assets in the user's photo library.
@Observable
final class PhotoLibraryAlbumManager: NSObject, @unchecked Sendable {
    /// Published property holding the collection of photo assets in the album.
    var photoAssets: PhotoAssetCollection = .init(PHFetchResult<PHAsset>())

    /// The local identifier of the asset collection.
    var identifier: String? {
        assetCollection?.localIdentifier
    }

    /// The name of the album.
    var albumName: String?

    /// The subtype of the smart album, if applicable.
    var smartAlbumType: PHAssetCollectionSubtype?

    /// Cache manager for photo library assets.
    let cache = PhotoLibraryCacheManager()

    private var assetCollection: PHAssetCollection?

    private var createAlbumIfNotFound = false

    private let logger: LogProtocol = Log(category: .photoLibrary)

    /// Enumeration for errors related to photo collections.
    enum PhotoCollectionError: LocalizedError {
        case missingAssetCollection
        case missingAlbumName
        case missingLocalIdentifier
        case unableToFindAlbum(String)
        case unableToLoadSmartAlbum(PHAssetCollectionSubtype)
        case addImageError(Error)
        case createAlbumError(Error)
        case removeAllError(Error)
    }

    /// Initializes a `PhotoLibraryAlbumManager` for a specific album name.
    /// - Parameters:
    ///   - albumName: The name of the album to manage.
    ///   - createIfNotFound: Boolean flag indicating whether to create the album if it does not exist.
    init(albumNamed albumName: String, createIfNotFound: Bool = false) {
        self.albumName = albumName
        createAlbumIfNotFound = createIfNotFound
        super.init()
    }

    /// Initializes a `PhotoLibraryAlbumManager` for an album with a specific identifier.
    /// - Parameter identifier: The identifier of the album.
    init?(albumWithIdentifier identifier: String) {
        guard let assetCollection = PhotoLibraryAlbumManager.getAlbum(identifier: identifier) else {
            logger.error("Photo album not found for identifier: \(identifier)")
            return nil
        }
        logger.debug("Loaded photo album with identifier: \(identifier)")
        self.assetCollection = assetCollection
        super.init()
        Task { [refresh = self.refreshPhotoAssets] in
            await refresh(nil)
        }
    }

    /// Initializes a `PhotoLibraryAlbumManager` for a specific smart album type.
    /// - Parameter smartAlbumType: The subtype of the smart album to manage.
    init(smartAlbum smartAlbumType: PHAssetCollectionSubtype) {
        self.smartAlbumType = smartAlbumType
        super.init()
    }

    deinit {
        // PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    /// Loads the photo album either by name or as a smart album.
    /// - Throws: `PhotoCollectionError` if the album cannot be found or created.
    func load() async throws {
        // PHPhotoLibrary.shared().register(self)

        if let smartAlbumType {
            if let assetCollection = PhotoLibraryAlbumManager.getSmartAlbum(subtype: smartAlbumType) {
                logger.debug("Loaded smart album of type: \(smartAlbumType.rawValue)")
                self.assetCollection = assetCollection
                await refreshPhotoAssets()
                return
            } else {
                logger.error("Unable to load smart album of type: : \(smartAlbumType.rawValue)")
                throw PhotoCollectionError.unableToLoadSmartAlbum(smartAlbumType)
            }
        }

        guard let name = albumName, !name.isEmpty else {
            logger.error("Unable to load an album without a name.")
            throw PhotoCollectionError.missingAlbumName
        }

        if let assetCollection = PhotoLibraryAlbumManager.getAlbum(named: name) {
            logger.debug("Loaded photo album named: \(name)")
            self.assetCollection = assetCollection
            await refreshPhotoAssets()
            return
        }

        guard createAlbumIfNotFound else {
            logger.error("Unable to find photo album named: \(name)")
            throw PhotoCollectionError.unableToFindAlbum(name)
        }
    }

    /// Refreshes the photo assets from the current asset collection.
    /// - Parameter fetchResult: Optional fetch result to use instead of fetching from the asset collection.
    private func refreshPhotoAssets(_ fetchResult: PHFetchResult<PHAsset>? = nil) async {
        var newFetchResult = fetchResult

        if newFetchResult == nil {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            if let assetCollection, let fetchResult = (PHAsset.fetchAssets(in: assetCollection, options: fetchOptions) as AnyObject?) as? PHFetchResult<PHAsset> {
                newFetchResult = fetchResult
            }
        }

        if let newFetchResult {
            await MainActor.run {
                photoAssets = PhotoAssetCollection(newFetchResult)
                logger.debug("PhotoCollection photoAssets refreshed: \(self.photoAssets.count)")
            }
        }
    }

    /// Fetches an album using its local identifier.
    /// - Parameter identifier: The local identifier of the album.
    /// - Returns: The `PHAssetCollection` with the specified identifier, if found.
    private static func getAlbum(identifier: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        let collections = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [identifier], options: fetchOptions)
        return collections.firstObject
    }

    /// Fetches an album using its name.
    /// - Parameter name: The name of the album.
    /// - Returns: The `PHAssetCollection` with the specified name, if found.
    private static func getAlbum(named name: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collections.firstObject
    }

    /// Fetches a smart album using its subtype.
    /// - Parameter subtype: The subtype of the smart album.
    /// - Returns: The `PHAssetCollection` with the specified subtype, if found.
    private static func getSmartAlbum(subtype: PHAssetCollectionSubtype) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: subtype, options: fetchOptions)
        return collections.firstObject
    }
}

/* extension PhotoLibraryAlbumManager: PHPhotoLibraryChangeObserver {

     func photoLibraryDidChange(_ changeInstance: PHChange) {
         Task { @MainActor in
             guard let changes = changeInstance.changeDetails(for: self.photoAssets.fetchResult) else { return }
             await self.refreshPhotoAssets(changes.fetchResultAfterChanges)
         }
     }
 } */
