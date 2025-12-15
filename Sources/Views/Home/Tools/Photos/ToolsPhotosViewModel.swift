//
//  ToolsPhotosViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 08.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Combine
import Photos
import SwiftCommons
import SwiftUI

/// ViewModel for managing and displaying photos from the photo library in the `ToolsPhotosView`.
///
/// `ToolsPhotosViewModel` handles photo fetching, authorization, and selection logic. It integrates with the photo library and manages state related to photo assets and user permissions.
///
/// - Properties:
///   - `viewSettings`: Settings related to the view's appearance, such as corner radius and padding.
///   - `logger`: A logging instance used for error reporting.
///   - `selectedAsset`: The currently selected photo asset.
///   - `selectedImage`: The currently selected image. Sets `selectedAsset` to nil if the image is cleared.
///   - `isAuthorised`: Boolean indicating if the app has permission to access the photo library.
///   - `photosAppManager`: Manager for photo library access and authorization.
///   - `isPhotosLoaded`: Boolean indicating if the photos have been loaded from the library.
///   - `photoLibraryAlbumManager`: Manages the photo library album and caching.
///   - `cellWidth`, `cellHeight`: Dimensions for the photo cells.
///   - `imageSize`, `thumbnailSize`: Sizes for fetching images and thumbnails.
///   - `cellCornerRadius`: Corner radius for the photo cell.

@Observable
final class ToolsPhotosViewModel: DomainViewConstantProtocol, @unchecked Sendable {
    typealias DomainViewConstantType = ToolsPhotosViewDomain

    let viewSettings: ToolsPhotosViewDomain = .init()

    private let logger: LogProtocol = Log(category: .toolsPhoto)

    private(set) var isAuthorised: Bool = true

    private let photosAppManager: PhotoLibraryAccessManagerProtocol
    var isPhotosLoaded = false

    var photoLibraryAlbumManager = PhotoLibraryAlbumManager(smartAlbum: .smartAlbumUserLibrary)

    var selectedPicture: NSImage?
    var selectedAsset: PhotoAsset?
    private(set) var selectedImagePublisher: PassthroughSubject<(NSImage?, PhotoAsset?), Never> = .init()

    var cellWidth: CGFloat { 192 }
    var cellHeight: CGFloat { 148 }

    var imageSize: CGSize { .init(width: 1024, height: 1024) }
    var thumbnailSize: CGSize { .init(width: 512, height: 512) }

    var cellCornerRadius: CGFloat { viewSettings.cornerRadius! }

    init() {
        photosAppManager = PhotoLibraryAccessManager()
    }

    /// Asynchronously fetches images from the photo library and checks authorization status.
    func fetchImages() async {
        guard !isPhotosLoaded else { return }

        let authorised = await photosAppManager.checkAuthorization()

        Task { @MainActor in
            isAuthorised = authorised
        }

        guard authorised else {
            return
        }

        Task {
            do {
                try await self.photoLibraryAlbumManager.load()
            } catch {
                logger.error("Failed to load photo collection: \(error.localizedDescription)")
            }

            Task { @MainActor in
                self.isPhotosLoaded = true
            }
        }
    }
}

extension ToolsPhotosViewModel {
    static var preview: ToolsPhotosViewModel {
        ToolsPhotosViewModel()
    }
}
