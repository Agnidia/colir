//
//  ToolsPhotosView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 31.08.2023.
//

import SwiftUI
import SystemSettingsAccess

struct ToolsPhotosView: View {
    
    @EnvironmentObject var viewModel: ToolsPhotosViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.cellWidth))], spacing: 16) {
                ForEach(viewModel.photoLibraryAlbumManager.photoAssets) { item in
                    viewModel.cell(for: item)
                }
            }
            .padding()
        }
        .overlay(content: {
            viewModel.overlay
        })
        .task(viewModel.fetchImages)
    }
}

#Preview("ToolsPhotosView") {
    ToolsPhotosView()
}
