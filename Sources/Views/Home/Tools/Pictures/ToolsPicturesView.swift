//
//  ToolsPicturesView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//

import SwiftUI

struct ToolsPicturesView: View {
    @EnvironmentObject var viewModel: ToolsPicturesViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: viewModel.columns, spacing: 16) {
                ForEach(viewModel.images, id: \.self) { item in
                    viewModel.cell(for: item)
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
