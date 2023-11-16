//
//  ToolsColorsViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 18.09.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

class ToolsColorsViewModel: ObservableObject {
    
    @Published private(set) var selectedColor: NSColor? = nil
    
    var colorGroups: [String : [NSColor]] = NSColor.groupsByType
    
    private let cellWidth: CGFloat = 128
    private let cellHeight: CGFloat = 48
    
    private let cellCornerRadius: CGFloat = 8
    
    var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: cellWidth))
        ]
    }
    
    @ViewBuilder
    func cell(for color: NSColor) -> some View {
        RoundedRectangle(cornerRadius: cellCornerRadius, style: .continuous)
            .fill(Color(nsColor: color))
            .frame(width: cellWidth, height: cellHeight)
            .cornerRadius(cellCornerRadius)
            .overlay(
                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: cellCornerRadius)
                        .strokeBorder(selectedColor == color ? Color.selectedView : Color.clear, lineWidth: 4)
                    if selectedColor == color {
                        Image(systemName: "checkmark.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.title)
                            .padding(8)
                    }
                }
            )
            .onTapGesture { [weak self] in
                if self?.selectedColor == color {
                    self?.selectedColor = nil
                } else {
                    self?.selectedColor = color
                }
            }
    }
}

extension ToolsColorsViewModel {
    static var preview: ToolsColorsViewModel {
        ToolsColorsViewModel()
    }
}
