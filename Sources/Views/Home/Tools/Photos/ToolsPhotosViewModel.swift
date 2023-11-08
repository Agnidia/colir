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

class ToolsPhotosViewModel: ObservableObject, DomainViewConstantProtocol {
    
    typealias DomainViewConstantType = ToolsPhotosViewDomain
    
    var viewSettings: ToolsPhotosViewDomain = .init()
    
    private let logger: LogProtocol = Log(category: .toolsPhoto)
    
    @Published var selectedAsset: PhotoAsset? = nil
    @Published private(set) var selectedImage: NSImage? = nil
        
    @Published var isAuthorized: Bool = true
    
    private let photosAppManager: PhotoLibraryAccessManagerProtocol
    
    @Published var isPhotosLoaded = false
    
    var photoLibraryAlbumManager = PhotoLibraryAlbumManager(smartAlbum: .smartAlbumUserLibrary)
    
    var imageSize = CGSize(width: 1024, height: 1024)
    
    let cellWidth: CGFloat = 192
    let cellHeight: CGFloat = 128
    
    let cellCornerRadius: CGFloat = 8
    
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
        ToolsPhotosItemView(asset: item, cache: photoLibraryAlbumManager.cache, imageSize: imageSize)
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
                                    self.selectedImage = image
                                }
                            }
                        }
                    }
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
