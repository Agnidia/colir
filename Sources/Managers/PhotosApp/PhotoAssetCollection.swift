//
//  PhotoAssetCollection.swift
//
//  Created on 10.10.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import Photos

import Photos

/// A collection of photo assets fetched from the photo library.
class PhotoAssetCollection: RandomAccessCollection {
    /// The underlying `PHFetchResult` containing the photo assets.
    private(set) var fetchResult: PHFetchResult<PHAsset>

    /// The current index for iteration.
    private var iteratorIndex: Int = .zero

    /// A cache to store `PhotoAsset` objects by their index.
    private var cache = [Int: PhotoAsset]()

    /// The starting index of the collection.
    var startIndex: Int { .zero }

    /// The ending index of the collection.
    var endIndex: Int { fetchResult.count }

    /// Initializes a `PhotoAssetCollection` with a `PHFetchResult` of photo assets.
    /// - Parameter fetchResult: The `PHFetchResult` containing the photo assets.
    init(_ fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
    }

    /// Accesses the `PhotoAsset` at the specified position in the collection.
    /// - Parameter position: The index of the photo asset.
    /// - Returns: The `PhotoAsset` at the specified position.
    subscript(position: Int) -> PhotoAsset {
        if let asset = cache[position] {
            return asset
        }
        let asset = PhotoAsset(phAsset: fetchResult.object(at: position), index: position)
        cache[position] = asset
        return asset
    }

    /// Returns an array of `PHAsset` objects from the `PHFetchResult`.
    var phAssets: [PHAsset] {
        var assets = [PHAsset]()
        fetchResult.enumerateObjects { object, _, _ in
            assets.append(object)
        }
        return assets
    }
}

extension PhotoAssetCollection: Sequence, IteratorProtocol {
    /// Provides the next `PhotoAsset` in the sequence.
    /// - Returns: The next `PhotoAsset` in the collection, or `nil` if the end of the collection is reached.
    func next() -> PhotoAsset? {
        if iteratorIndex >= count {
            return nil
        }

        defer {
            iteratorIndex += 1
        }

        return self[iteratorIndex]
    }
}
