//
//  ToolsColorsView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 31.08.2023.
//

import SwiftUI

struct ToolsColorsView: View {
    
    @EnvironmentObject var viewModel: ToolsColorsViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: viewModel.columns, spacing: 16) {
                ForEach(viewModel.colorGroups.sorted(by: { $0.key < $1.key }), id: \.key) { groupKey, colors in
                    Section(header: Text(groupKey).font(.headline).padding(.top, 8)) {
                        ForEach(colors, id: \.self) { color in
                            viewModel.cell(for: color)
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
    }
}

#Preview("ToolsColorsView") {
    ToolsColorsView()
        .environmentObject(ToolsColorsViewModel.preview)
}
