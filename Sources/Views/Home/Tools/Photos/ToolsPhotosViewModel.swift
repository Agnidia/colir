//
//  ToolsPhotosViewModel.swift
//  colir
//
//  Created by Vitalii P on 08.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Photos

class ToolsPhotosViewModel: ObservableObject {
    
    private let logger: LogProtocol = Log(category: .toolsPhoto)
        
    @Published var selectedImage: PhotoAsset? = nil
    
    @Published var isAuthorized: Bool = true
    
    private let photosAppManager: PhotoLibraryAccessManagerProtocol
        
    var isPhotosLoaded = false
    
    var photoLibraryAlbumManager = PhotoLibraryAlbumManager(smartAlbum: .smartAlbumUserLibrary)
    
    var imageSize = CGSize(width: 1024, height: 1024)
    
    let cellWidth: CGFloat = 192
    let cellHeight: CGFloat = 128
    
    let cellCornerRadius: CGFloat = 8
    
    init() {
        self.photosAppManager = PhotoLibraryAccessManager()
    }
    
    @Sendable
    func fetchImages() async {
        guard !isPhotosLoaded else { return }
        
        let authorized = await photosAppManager.checkAuthorization()
        guard authorized else {
            Task { @MainActor in
                isAuthorized = false
            }
            return
        }
        
        Task {
            do {
                try await self.photoLibraryAlbumManager.load()
            } catch let error {
                logger.error("Failed to load photo collection: \(error.localizedDescription)")
            }
            self.isPhotosLoaded = true
        }
        
        Task { @MainActor in
            isAuthorized = false
        }
    }
}
