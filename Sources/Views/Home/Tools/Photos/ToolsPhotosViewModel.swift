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

class ToolsPhotosViewModel: ObservableObject {
    
    private let logger: LogProtocol = Log(category: .toolsPhoto)
        
    @Published var selectedImage: PhotoAsset? = nil
    
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
                .environmentObject(PermissionsOverlayViewModel(title: "Open Photos permissions", url: url))
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
