//
//  PhotoLibraryAccessManager.swift
//  colir
//
//  Created by Vitalii P on 08.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
import Photos

/// A protocol that defines methods for managing images in the "Photos.app".
protocol PhotoLibraryAccessManagerProtocol {
    
    func checkAuthorization() async -> Bool
}

class PhotoLibraryAccessManager: PhotoLibraryAccessManagerProtocol {
    
    private let logger: LogProtocol = Log(category: .photoAppAccess)
    
    func checkAuthorization() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            logger.debug("Photo library access authorized.")
            return true
        case .notDetermined:
            logger.debug("Photo library access not determined.")
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
            return false
        }
    }
}
