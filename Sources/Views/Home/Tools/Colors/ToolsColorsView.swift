//
//  ToolsColorsView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 31.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Algorithms

/// A view that displays a list of color options for selection.
///
/// `ToolsColorsView` uses a view model to provide color options and a title for the color picker.
/// It presents a scrollable list of colors that the user can select from.
///
/// - Environment:
///   - `viewModel`: An instance of `ToolsColorsViewModel` that provides data and behavior for the view.
///
/// - Views:
///   - `colorPickerTitle`: A view displaying the title for the color picker.
///   - `colorsList`: A view displaying a list of color options for the user to choose from.
struct ToolsColorsView: View {
    
    @Environment(ToolsColorsViewModel.self) var viewModel
    
    @State private var selectedColor: NSColor? = nil
    
    @State private var colorGroups: [String : [NSColor]] = NSColor.groupsByType
    
    var body: some View {
        ScrollView {
            colorPickerTitle
            
            colorsList
        }
        .onChange(of: selectedColor) { oldValue, newValue in
            viewModel.selectedColor = newValue
            viewModel.selectedColorPublisher.send(newValue)
        }
        .onChange(of: viewModel.selectedColor) { oldValue, newValue in
            selectedColor = newValue
        }
    }
    
    var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: viewModel.cellWidth))
        ]
    }
    
    @ViewBuilder
    var colorPickerTitle: some View {
        VStack(spacing: viewModel.viewSettings.spacing) {
            Text(ToolsColorsViewDomain.Localization.customColor)
                .font(.headline)
            
            ColorPicker(selection: Binding(get: { Color(nsColor: selectedColor ?? .clear) },
                                           set: { selectedColor = NSColor($0) }), supportsOpacity: false) {}
                .scaleEffect(x: 2, y: 2)
            
            Divider()
                .padding(viewModel.viewSettings.padding)
        }
        .padding(viewModel.viewSettings.padding)
    }
    
    @ViewBuilder
    var colorsList: some View {
        LazyVGrid(columns: columns, spacing: viewModel.viewSettings.spacing) {
            ForEach(colorGroups.sorted(by: { $0.key < $1.key }), id: \.key) { groupKey, colors in
                Section(header: Text(groupKey.capitalized)
                    .font(.headline)
                    .padding(.top, .paddingSmall)) {
                        ForEach(colors, id: \.self) { cell(for: $0) }
                    }
            }
        }
        .padding(EdgeInsets(top: .zero, leading: .paddingDefault, bottom: .paddingDefault, trailing: .paddingDefault))
    }
    
    @ViewBuilder
    private func cell(for color: NSColor) -> some View {
        RoundedRectangle(cornerRadius: viewModel.cellCornerRadius, style: .continuous)
            .fill(Color(nsColor: color))
            .frame(width: viewModel.cellWidth, height: viewModel.cellHeight)
            .cornerRadius(viewModel.cellCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: viewModel.cellCornerRadius)
                    .strokeBorder(selectedColor == color ? Color.selectedView : Color.clear, lineWidth: 4)
                    .overlay {
                        ZStack {
                            Image(systemName: ToolsColorsViewDomain.Icon.selected)
                                .symbolRenderingMode(.multicolor)
                                .font(.title)
                                .padding(viewModel.viewSettings.padding)
                                .opacity(selectedColor == color ? .opacity100 : .opacity0)
                                .animation(.default, value: selectedColor)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    }
            )
            .onTapGesture {
                if selectedColor == color {
                    selectedColor = nil
                } else {
                    selectedColor = color
                }
            }
    }
}

#Preview("ToolsColorsView") {
    ToolsColorsView()
        .environment(ToolsColorsViewModel.preview)
}
