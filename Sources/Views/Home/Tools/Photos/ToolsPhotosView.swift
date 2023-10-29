//
//  ToolsPhotosView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 31.08.2023.
//

import SwiftUI

struct ToolsPhotosView: View {
    
    @EnvironmentObject var viewModel: ToolsPhotosViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.cellWidth))], spacing: 16) {
                ForEach(viewModel.photoLibraryAlbumManager.photoAssets) { item in
                    ToolsPhotosItemView(asset: item, cache: viewModel.photoLibraryAlbumManager.cache, imageSize: viewModel.imageSize)
                        .frame(width: viewModel.cellWidth, height: viewModel.cellHeight)
                        .cornerRadius(viewModel.cellCornerRadius)
                        .overlay(
                            ZStack(alignment: .bottomTrailing) {
                                let isSelected = viewModel.selectedImage == item
                                RoundedRectangle(cornerRadius: viewModel.cellCornerRadius)
                                    .strokeBorder(isSelected ? Color.blue : Color.gray, lineWidth: isSelected ? 4 : 1)
                                if isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .symbolRenderingMode(.multicolor)
                                        .font(.title)
                                        .padding(8)
                                }
                            }
                        )
                        .onTapGesture {
                            viewModel.selectedImage = item
                        }
                }
            }
            .padding()
        }
        .overlay(content: {
            if viewModel.isAuthorized == false, let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Photos") {
                PermissionsOverlayView()
                    .environmentObject(PermissionsOverlayViewModel(title: "Open Photos permissions", url: url))
            }
        })
        .task(viewModel.fetchImages)
    }
}

#Preview("ToolsPhotosView") {
    ToolsPhotosView()
}
