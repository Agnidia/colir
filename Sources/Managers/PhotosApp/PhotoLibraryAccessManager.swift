//
//  PhotoLibraryAccessManager.swift
//
//  Created on 10.10.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Foundation
import Photos

/// A protocol that defines methods for managing images in the "Photos.app".
protocol PhotoLibraryAccessManagerProtocol {
    /// Checks the authorization status for accessing the photo library.
    /// - Returns: A Boolean value indicating whether access is authorized.
    func checkAuthorization() async -> Bool
}

/// A class that manages photo library access and authorization.
final class PhotoLibraryAccessManager: PhotoLibraryAccessManagerProtocol {
    private let logger: LogProtocol = Log(category: .photoAppAccess)

    /// Checks the authorization status for accessing the photo library.
    /// - Returns: A Boolean value indicating whether access is authorized. The method may request authorization if the status is not yet determined.
    func checkAuthorization() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            logger.debug("Photo library access authorized.")
            return true
        case .notDetermined:
            logger.debug("Photo library access not determined.")
            // Request authorization if not determined
            return await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
        case .denied:
            logger.debug("Photo library access denied.")
            return false
        case .limited:
            logger.debug("Photo library access limited.")
            return false
        case .restricted:
            logger.debug("Photo library access restricted.")
            return false
        @unknown default:
            // Handle any new cases that might be added in future versions of the framework
            return false
        }
    }
}
