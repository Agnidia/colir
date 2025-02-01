//
//  ToolsPhotosView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 31.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SystemSettingsAccess

/// A SwiftUI view that displays photos from the user's photo library.
///
/// `ToolsPhotosView` presents a grid of photos fetched from the user's photo library. It utilizes a `ToolsPhotosViewModel` to manage the photo fetching and display logic. The view supports overlaying additional content and updating the displayed images asynchronously.
///
/// - Environment Objects:
///   - `viewModel`: The view model (`ToolsPhotosViewModel`) that provides the data and functionality for the view.
///
/// - Views:
///   - `ScrollView`: A scrollable container for the photo grid.
///   - `LazyVGrid`: A grid layout that adapts to the available width, displaying photo items.
///   - `overlay`: An additional layer that can be used for displaying overlays, such as loading indicators or error messages.
///
/// - Tasks:
///   - `task`: Fetches images asynchronously when the view appears.
///
/// - Preview:
///   - A preview instance of `ToolsPhotosView` is provided to visualize the view's layout and behavior in Xcode's canvas.
struct ToolsPhotosView: View {
    
    @Environment(ToolsPhotosViewModel.self) var viewModel
    
    @State private var selectedAsset: PhotoAsset? = nil
    
    @State private var selectedImage: NSImage? = nil {
        didSet {
            if selectedImage == nil {
                selectedAsset = nil
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.cellWidth))], spacing: .spacingHeight) {
                ForEach(viewModel.photoLibraryAlbumManager.photoAssets, content: cell(for:))
            }
            .padding(.paddingDefault)
        }
        .overlay(content: overlay)
        .task(viewModel.fetchImages)
    }
    
    @ViewBuilder
    private func overlay() -> some View {
        if viewModel.isAuthorised == false, let url = SystemSettingsSecurityPrivacy.photos.path {
            PermissionsOverlayView()
                .environmentObject(PermissionsOverlayViewModel(title: ToolsPhotosViewDomain.Localization.photoDescription, url: url))
        }
    }
    
    /// Creates a cell view for a given photo asset, with selection handling and image fetching.
    @ViewBuilder
    func cell(for item: PhotoAsset) -> some View {
        ToolsPhotosItemView(asset: item, cache: viewModel.photoLibraryAlbumManager.cache, imageSize: viewModel.thumbnailSize)
            .frame(maxWidth: .infinity, minHeight: viewModel.cellHeight, maxHeight: viewModel.cellHeight, alignment: .center)
            .cornerRadius(viewModel.cellCornerRadius)
            .overlay(
                ZStack(alignment: .bottomTrailing) {
                    let isSelected = selectedAsset == item
                    RoundedRectangle(cornerRadius: viewModel.cellCornerRadius)
                        .strokeBorder(isSelected ? Color.selectedView : Color.gray, lineWidth: isSelected ? 4 : 1)
                    
                    Image(systemName: ToolsPhotosViewDomain.Icon.selection)
                        .symbolRenderingMode(.multicolor)
                        .font(.title)
                        .padding(viewModel.viewSettings.padding)
                        .opacity(isSelected ? .opacity100 : .opacity0)
                        .animation(.default, value: selectedAsset)
                }
            )
            .onTapGesture { select(item: item) }
            .onChange(of: viewModel.selectedAsset) { _, newValue in
                selectedAsset = newValue
            }
            .onChange(of: viewModel.selectedPicture) { _, newValue in
                selectedImage = newValue
            }
    }
    
    private func select(item: PhotoAsset) {
        if selectedAsset == item {
            selectedAsset = nil
        } else {
            selectedAsset = item
        }
        
        guard let selectedAsset = self.selectedAsset else {
            self.selectedImage = nil
            viewModel.selectedImagePublisher.send((nil, nil))
            return
        }
        
        let imageSize = viewModel.imageSize
        let cache = viewModel.photoLibraryAlbumManager.cache
        
        Task {
            _ = await cache.requestImage(for: selectedAsset, targetSize: imageSize) { result in
                
                guard result?.isLowerQuality == false, let image = result?.image else { return }
                
                self.selectedImage = image
                viewModel.selectedImagePublisher.send((image, selectedAsset))
            }
        }
    }
}

#Preview("ToolsPhotosView") {
    ToolsPhotosView()
        .environment(ToolsPhotosViewModel())
}
