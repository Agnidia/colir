//
//  ToolsColorsView.swift
//  colir
//
//  Created by Vitalii P on 31.08.2023.
//

import SwiftUI

struct ToolsColorsView: View {
    
    @EnvironmentObject var viewModel: ToolsColorsViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.cellWidth))], spacing: 16) {
                ForEach(viewModel.colorGroups.sorted(by: { $0.key < $1.key }), id: \.key) { groupKey, colors in
                    Section(header: Text(groupKey).font(.headline).padding(.top, 8)) {
                        ForEach(colors, id: \.self) { color in
                            RoundedRectangle(cornerRadius: viewModel.cellCornerRadius, style: .continuous)
                                .fill(Color(nsColor: color))
                                .frame(width: viewModel.cellWidth, height: viewModel.cellHeight)
                                .cornerRadius(viewModel.cellCornerRadius)
                                .overlay(
                                    ZStack(alignment: SwiftUI.Alignment.bottomTrailing) {
                                        RoundedRectangle(cornerRadius: viewModel.cellCornerRadius)
                                            .strokeBorder(viewModel.selectedColor == color ? Color.blue : Color.clear, lineWidth: 4)
                                        if viewModel.selectedColor == color {
                                            Image(systemName: "checkmark.circle.fill")
                                                .symbolRenderingMode(.multicolor)
                                                .font(.title)
                                                .padding(8)
                                        }
                                    }
                                )
                                .onTapGesture {
                                    viewModel.selectedColor = color
                                }
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
