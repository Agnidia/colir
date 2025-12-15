//
//  PhotoAsset.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 09.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Photos

/// A struct representing a photo asset in the photo library.
struct PhotoAsset: Identifiable, Sendable {
    /// The unique identifier for the asset.
    var id: String { identifier }

    /// The unique identifier for the asset, default is a newly generated UUID string.
    var identifier: String = UUID().uuidString

    /// The index of the asset, if available.
    var index: Int?

    /// The underlying `PHAsset` object representing the photo asset.
    var phAsset: PHAsset?

    /// Type alias for `PHAssetMediaType`.
    typealias MediaType = PHAssetMediaType

    /// The media type of the asset.
    var mediaType: MediaType {
        phAsset?.mediaType ?? .unknown
    }

    /// Initializes a `PhotoAsset` with a `PHAsset` and an optional index.
    /// - Parameters:
    ///   - phAsset: The `PHAsset` object representing the photo asset.
    ///   - index: The index of the asset, if applicable.
    init(phAsset: PHAsset, index: Int?) {
        self.phAsset = phAsset
        self.index = index
        identifier = phAsset.localIdentifier
    }

    /// Initializes a `PhotoAsset` with a local identifier.
    /// - Parameter identifier: The local identifier of the photo asset.
    init(identifier: String) {
        self.identifier = identifier
        let fetchedAssets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        phAsset = fetchedAssets.firstObject
    }
}

extension PhotoAsset: Equatable {
    /// Compares two `PhotoAsset` instances for equality based on their identifiers.
    /// - Parameters:
    ///   - lhs: The left-hand side `PhotoAsset`.
    ///   - rhs: The right-hand side `PhotoAsset`.
    /// - Returns: `true` if the identifiers are equal, otherwise `false`.
    static func == (lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension PhotoAsset: Hashable {
    /// Hashes the identifier of the `PhotoAsset` for use in hash-based collections.
    /// - Parameter hasher: The hasher to use for hashing.
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension PHObject: @retroactive Identifiable {
    /// Provides a unique identifier for `PHObject` based on its local identifier.
    public var id: String { localIdentifier }
}
