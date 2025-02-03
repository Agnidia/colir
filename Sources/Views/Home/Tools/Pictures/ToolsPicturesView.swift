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
            LazyVGrid(columns: viewModel.columns, spacing: .spacingHeight) {
                ForEach(viewModel.images, id: \.self) { cell(for: $0) }
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
        Image(nsImage: item.image)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, minHeight: viewModel.cellHeight, maxHeight: viewModel.cellHeight, alignment: .center)
            .cornerRadius(viewModel.cellCornerRadius)
            .clipShape(RoundedRectangle(cornerRadius: viewModel.cellCornerRadius))
            .overlay(
                ZStack(alignment: .bottomTrailing) {
                    let isSelected = viewModel.selectedImage == item
                    RoundedRectangle(cornerRadius: viewModel.cellCornerRadius)
                        .strokeBorder(isSelected ? Color.selectedView : Color.secondaryText, lineWidth: isSelected ? 4 : 1)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.primaryText, Color.selectedView)
                        .font(.title)
                        .padding(.paddingSmall)
                        .opacity(isSelected ? .opacity100 : .opacity0)
                        .animation(.default, value: viewModel.selectedImage)
                }
            )
            .onTapGesture {
                if viewModel.selectedImage == item {
                    viewModel.selectedImage = nil
                } else {
                    viewModel.selectedImage = item
                }
            }
            .contentShape(Rectangle())
    }
}

#Preview("ToolsPicturesView") {
    ToolsPicturesView()
        .environmentObject(ToolsPicturesViewModel.preview)
}
