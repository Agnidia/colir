//
//  ToolsPhotosView.swift
//
//  Created on 07.10.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
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

    @State private var previewImage: NSImage? = nil

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.cellWidth))], spacing: .spacingHeight) {
                ForEach(viewModel.photoLibraryAlbumManager.photoAssets, content: cell(for:))
            }
            .padding(.paddingDefault)
        }
        .overlay(content: overlay)
        .task(viewModel.fetchImages)
        .onChange(of: viewModel.selectedAsset) { _, newValue in
            selectedAsset = newValue
        }
        .onChange(of: viewModel.selectedPicture) { _, newValue in
            selectedImage = newValue
        }
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
        SelectableGridCell(
            isSelected: selectedAsset == item,
            cornerRadius: viewModel.cellCornerRadius,
            accessibilityLabel: item.id,
            accessibilityHint: "Tap to add this photo to the folder"
        ) {
            ToolsPhotosItemView(asset: item, cache: viewModel.photoLibraryAlbumManager.cache, imageSize: viewModel.thumbnailSize)
                .frame(minWidth: viewModel.cellWidth, maxWidth: .infinity, minHeight: viewModel.cellHeight, maxHeight: viewModel.cellHeight, alignment: .center)
        } onTap: {
            select(item: item)
        }
    }

    private func select(item: PhotoAsset) {
        if selectedAsset == item {
            selectedAsset = nil
        } else {
            selectedAsset = item
        }

        guard let selectedAsset else {
            selectedImage = nil
            viewModel.selectedImagePublisher.send((nil, nil))
            return
        }

        let imageSize = viewModel.imageSize
        let cache = viewModel.photoLibraryAlbumManager.cache

        previewImage = nil

        Task {
            _ = await cache.requestImage(for: selectedAsset, targetSize: imageSize) { result in
                if result?.isLowerQuality == true, let image = result?.image {
                    previewImage = image
                    return
                }

                guard let image = result?.image ?? previewImage else { return }

                previewImage = nil
                selectedImage = image
                viewModel.selectedImagePublisher.send((image, selectedAsset))
            }
        }
    }
}

#Preview("ToolsPhotosView") {
    ToolsPhotosView()
        .environment(ToolsPhotosViewModel())
}
