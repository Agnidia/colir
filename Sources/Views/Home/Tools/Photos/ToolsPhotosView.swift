//
//  ToolsPhotosView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 31.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

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
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.cellWidth))], spacing: .spacingHeight) {
                ForEach(viewModel.photoLibraryAlbumManager.photoAssets) { item in
                    viewModel.cell(for: item)
                }
            }
            .padding(.paddingDefault)
        }
        .overlay(content: {
            viewModel.overlay
        })
        .task(viewModel.fetchImages)
    }
}

#Preview("ToolsPhotosView") {
    ToolsPhotosView()
        .environment(ToolsPhotosViewModel())
}
