//
//  ToolsPicturesView.swift
//  colir
//
//  Created by Vitalii P on 07.10.2023.
//

import SwiftUI

struct ToolsPicturesView: View {
    @EnvironmentObject var viewModel: ToolsPicturesViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.cellWidth))], spacing: 16) {
                ForEach(viewModel.images, id: \.self) { item in
                    Image(nsImage: item.image)
                        .resizable()
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
        .task(viewModel.fetchImages)
    }
}

#Preview("ToolsPicturesView") {
    ToolsPicturesView()
        .environmentObject(ToolsPicturesViewModel.preview)
}
