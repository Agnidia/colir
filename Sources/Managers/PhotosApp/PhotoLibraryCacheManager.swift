//
//  PhotoLibraryCacheManager.swift
//
//  Created on 10.10.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import Foundation
import Photos
import SwiftUI

/// Manages the caching and retrieval of images from the photo library.
actor PhotoLibraryCacheManager {
    private let imageManager = PHCachingImageManager()

    private var imageContentMode = PHImageContentMode.aspectFit

    /// Errors that can occur while managing cached images.
    enum CachedImageManagerError: LocalizedError {
        case error(Error)
        case cancelled
        case failed
    }

    private var cachedAssetIdentifiers = [String: Bool]()

    private lazy var requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        return options
    }()

    init() {
        imageManager.allowsCachingHighQualityImages = false
    }

    /// The count of cached images.
    var cachedImageCount: Int {
        cachedAssetIdentifiers.keys.count
    }

    /// Starts caching images for the provided photo assets.
    /// - Parameters:
    ///   - assets: An array of `PhotoAsset` instances to cache.
    ///   - targetSize: The target size for the cached images.
    func startCaching(for assets: [PhotoAsset], targetSize: CGSize) {
        let phAssets = assets.compactMap(\.phAsset)
        for phAsset in phAssets {
            cachedAssetIdentifiers[phAsset.localIdentifier] = true
        }
        imageManager.startCachingImages(for: phAssets, targetSize: targetSize, contentMode: imageContentMode, options: requestOptions)
    }

    /// Stops caching images for the provided photo assets.
    /// - Parameters:
    ///   - assets: An array of `PhotoAsset` instances to stop caching.
    ///   - targetSize: The target size for the cached images.
    func stopCaching(for assets: [PhotoAsset], targetSize: CGSize) {
        let phAssets = assets.compactMap(\.phAsset)
        for phAsset in phAssets {
            cachedAssetIdentifiers.removeValue(forKey: phAsset.localIdentifier)
        }
        imageManager.stopCachingImages(for: phAssets, targetSize: targetSize, contentMode: imageContentMode, options: requestOptions)
    }

    /// Stops caching all images.
    func stopCaching() {
        imageManager.stopCachingImagesForAllAssets()
    }

    typealias ImageResult = (image: NSImage?, isLowerQuality: Bool)?

    /// Requests an image for a specific photo asset.
    /// - Parameters:
    ///   - asset: The `PhotoAsset` for which to request the image.
    ///   - targetSize: The target size for the requested image.
    ///   - completion: A closure to be called with the requested image and a flag indicating if the image is of lower quality.
    /// - Returns: The request ID for the image request, or `nil` if the asset is not available.
    @discardableResult
    func requestImage(for asset: PhotoAsset, targetSize: CGSize, completion: @escaping @Sendable @MainActor (ImageResult) -> Void) -> PHImageRequestID? {
        guard let phAsset = asset.phAsset else {
            Task { @MainActor in
                completion(nil)
            }
            return nil
        }

        let requestID = imageManager.requestImage(for: phAsset, targetSize: targetSize, contentMode: imageContentMode, options: requestOptions) { image, info in
            if info?[PHImageErrorKey] is Error {
                // Handle image request error
                Task { @MainActor in
                    completion(nil)
                }
            } else if let cancelled = (info?[PHImageCancelledKey] as? NSNumber)?.boolValue, cancelled {
                // Handle cancelled request
                Task { @MainActor in
                    completion(nil)
                }
            } else if let image {
                let isLowerQualityImage = (info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false
                let result = (image: image, isLowerQuality: isLowerQualityImage)
                Task { @MainActor [result] in
                    completion(result)
                }
            } else {
                Task { @MainActor in
                    completion(nil)
                }
            }
        }
        return requestID
    }

    /// Cancels an image request with the specified request ID.
    /// - Parameter requestID: The request ID of the image request to cancel.
    func cancelImageRequest(for requestID: PHImageRequestID) {
        imageManager.cancelImageRequest(requestID)
    }
}
