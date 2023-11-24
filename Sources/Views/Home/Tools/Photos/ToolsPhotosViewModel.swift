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

class ToolsPhotosViewModel: ObservableObject, DomainViewConstantProtocol {
    
    typealias DomainViewConstantType = ToolsPhotosViewDomain
    
    var viewSettings: ToolsPhotosViewDomain = .init()
    
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
    
    @Published var isAuthorized: Bool = true
    
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
        if isAuthorized == false, let url = SystemSettingsSecurityPrivacy.photos.path {
            PermissionsOverlayView()
                .environmentObject(PermissionsOverlayViewModel(title: ToolsPhotosViewDomain.Localization.photoDescription, url: url))
        } else {
            EmptyView()
        }
    }
    
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
    
    @Sendable
    func fetchImages() async {
        guard !isPhotosLoaded else { return }
        
        let authorized = await photosAppManager.checkAuthorization()
        
        Task { @MainActor in
            isAuthorized = authorized
        }
        
        guard authorized else {
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
