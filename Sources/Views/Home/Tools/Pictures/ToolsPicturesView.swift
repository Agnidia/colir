//
//  ToolsPicturesView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct ToolsPicturesView: View {
    @EnvironmentObject var viewModel: ToolsPicturesViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: viewModel.columns, spacing: .spacingHeight) {
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
