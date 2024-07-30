//
//  ToolsPhotosViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 08.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Photos
import SystemSettingsAccess
import SwiftCommons
import Throttler

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

class ToolsPhotosViewModel: ObservableObject, DomainViewConstantProtocol {
    
    typealias DomainViewConstantType = ToolsPhotosViewDomain
    
    let viewSettings: ToolsPhotosViewDomain = .init()
    
    private let logger: LogProtocol = Log(category: .toolsPhoto)
    
    @Published var selectedAsset: PhotoAsset? = nil
    
    //TODO: set it private(set)
    @Published var selectedImage: NSImage? = nil {
        didSet {
            if selectedImage == nil {
                selectedAsset = nil
            }
        }
    }
    
    @Published var isAuthorised: Bool = true
    
    private let photosAppManager: PhotoLibraryAccessManagerProtocol
    
    @Published var isPhotosLoaded = false
    
    var photoLibraryAlbumManager = PhotoLibraryAlbumManager(smartAlbum: .smartAlbumUserLibrary)
    
    let cellWidth: CGFloat = 192
    let cellHeight: CGFloat = 128
    
    var imageSize = CGSize(width: 1024, height: 1024)
    var thumbnailSize = CGSize(width: 512, height: 512)
    
    private lazy var cellCornerRadius: CGFloat = viewSettings.cornerRadius!
    
    init() {
        self.photosAppManager = PhotoLibraryAccessManager()
    }
    
    @ViewBuilder
    var overlay: some View {
        if isAuthorised == false, let url = SystemSettingsSecurityPrivacy.photos.path {
            PermissionsOverlayView()
                .environmentObject(PermissionsOverlayViewModel(title: ToolsPhotosViewDomain.Localization.photoDescription, url: url))
        } else {
            EmptyView()
        }
    }
    
    /// Creates a cell view for a given photo asset, with selection handling and image fetching.
    @ViewBuilder
    func cell(for item: PhotoAsset) -> some View {
        ToolsPhotosItemView(asset: item, cache: photoLibraryAlbumManager.cache, imageSize: thumbnailSize)
            .frame(width: cellWidth, height: cellHeight)
            .cornerRadius(cellCornerRadius)
            .overlay(
                ZStack(alignment: .bottomTrailing) {
                    let isSelected = selectedAsset == item
                    RoundedRectangle(cornerRadius: cellCornerRadius)
                        .strokeBorder(isSelected ? Color.selectedView : Color.gray, lineWidth: isSelected ? 4 : 1)
                    if isSelected {
                        Image(systemName: ToolsPhotosViewDomain.Icon.selection)
                            .symbolRenderingMode(.multicolor)
                            .font(.title)
                            .padding(viewSettings.padding)
                    }
                }
            )
            .onTapGesture { [weak self] in
                if self?.selectedAsset == item {
                    self?.selectedAsset = nil
                } else {
                    self?.selectedAsset = item
                }
                
                if let selectedAsset = self?.selectedAsset, let imageSize = self?.imageSize, let cache = self?.photoLibraryAlbumManager.cache {
                    
                    guard let self = self else { return }
                    
                    Task {
                        _ = await cache.requestImage(for: selectedAsset, targetSize: imageSize) { result in
                            
                            if let image = result?.image {
                                Task { @MainActor in
                                    debounce(.milliseconds(100)) { [weak self] in
                                        self?.selectedImage = image
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self?.selectedImage = nil
                }
            }
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
            } catch let error {
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
