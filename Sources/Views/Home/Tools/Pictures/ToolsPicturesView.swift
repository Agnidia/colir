//
//  ToolsPicturesView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A view that displays a grid of pictures for the user to browse and select.
///
/// The `ToolsPicturesView` uses a `ScrollView` and `LazyVGrid` to present a scrollable grid of images.
/// It is designed to work with the `ToolsPicturesViewModel` for managing the collection of images
/// and providing the cell view for each image.
///
/// - Environment Object:
///   - `viewModel`: An instance of `ToolsPicturesViewModel` that provides the data and logic for
///     fetching and displaying the pictures.
///
/// - Layout:
///   - Uses a `ScrollView` to allow vertical scrolling of the grid.
///   - Uses `LazyVGrid` to create a grid layout with columns defined in the `viewModel`.
///   - Each image in the grid is displayed using a cell view provided by the `viewModel`.
///
/// - Task:
///   - On view appearance (`.task` modifier), it triggers the `fetchImages` method of the `viewModel`
///     to load the images asynchronously.
struct ToolsPicturesView: View {
    @EnvironmentObject var viewModel: ToolsPicturesViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.cellWidth))], spacing: .spacingHeight) {
                ForEach(viewModel.images, content: cell(for:))
            }
            .padding(.paddingDefault)
        }
        .task(viewModel.fetchImages)
    }
    
    /// Generates a view for a given `PictureItem`, including a selection indication overlay.
    ///
    /// - Parameter item: The `PictureItem` to be displayed in the grid.
    /// - Returns: A `View` representing the image cell, with selection indication if applicable.
    @ViewBuilder
    func cell(for item: PictureItem) -> some View {
        SelectableGridCell(
            isSelected: viewModel.selectedImage == item,
            cornerRadius: viewModel.cellCornerRadius,
            accessibilityLabel: item.name,
            accessibilityHint: "tap to add this picture to the folder"
        ) {
            Image(nsImage: item.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: viewModel.cellWidth, maxWidth: .infinity, minHeight: viewModel.cellHeight, maxHeight: viewModel.cellHeight, alignment: .center)
        } onTap: {
            if viewModel.selectedImage == item {
                viewModel.selectedImage = nil
            } else {
                viewModel.selectedImage = item
            }
        }
    }
}

#Preview("ToolsPicturesView") {
    ToolsPicturesView()
        .environmentObject(ToolsPicturesViewModel.preview)
}
