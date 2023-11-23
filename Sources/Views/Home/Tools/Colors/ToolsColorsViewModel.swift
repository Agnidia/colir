//
//  ToolsColorsViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 18.09.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons
import Throttler

class ToolsColorsViewModel: ObservableObject, DomainViewConstantProtocol {
    typealias DomainViewConstantType = ToolsColorsViewDomain
    
    var viewSettings: ToolsColorsViewDomain = .init()
    
    @Published var selectedColor: NSColor? = nil
    
    var colorGroups: [String : [NSColor]] = NSColor.groupsByType
    
    private let cellWidth: CGFloat = 128
    private let cellHeight: CGFloat = 48
    
    private lazy var cellCornerRadius: CGFloat = viewSettings.cornerRadius!
    
    var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: cellWidth))
        ]
    }
    
    @ViewBuilder
    var colorPickerTitle: some View {
        VStack(spacing: viewSettings.spacing) {
            Text(DomainViewConstantType.Localization.customColor)
                .font(.headline)
            
            ColorPicker(selection: Binding(get: {
                Color(nsColor: self.selectedColor ?? .clear)
            }, set: { value in
                debounce(.milliseconds(200)) {
                    self.selectedColor = NSColor(value)
                }
            })) {
                EmptyView()
            }
            .scaleEffect(x: 2, y: 2)
            
            /*ColorWheelView()
                .frame(width: 200, height: 200)*/
            
            Divider()
                .padding(viewSettings.padding)
        }
        .padding(viewSettings.padding)
    }
    
    @ViewBuilder
    var colorsList: some View {
        LazyVGrid(columns: columns, spacing: viewSettings.spacing) {
            ForEach(colorGroups.sorted(by: { $0.key < $1.key }), id: \.key) { groupKey, colors in
                Section(header: Text(groupKey)
                    .font(.headline)
                    .padding(.top, 8)) {
                        ForEach(colors, id: \.self) { color in
                            self.cell(for: color)
                        }
                    }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
    }
    
    @ViewBuilder
    private func cell(for color: NSColor) -> some View {
        RoundedRectangle(cornerRadius: cellCornerRadius, style: .continuous)
            .fill(Color(nsColor: color))
            .frame(width: cellWidth, height: cellHeight)
            .cornerRadius(cellCornerRadius)
            .overlay(
                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: cellCornerRadius)
                        .strokeBorder(selectedColor == color ? Color.selectedView : Color.clear, lineWidth: 4)
                    if selectedColor == color {
                        Image(systemName: DomainViewConstantType.Icon.selected)
                            .symbolRenderingMode(.multicolor)
                            .font(.title)
                            .padding(viewSettings.padding)
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
