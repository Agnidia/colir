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

/// View model responsible for managing color selection and display in the `ToolsColorsView`.
///
/// `ToolsColorsViewModel` provides the necessary data and behavior for displaying color options and handling user selection. It includes functionality for updating the selected color and rendering the color picker and list of colors.
///
/// - Inherits:
///   - `ObservableObject`: Allows the view to observe changes in the model.
///   - `DomainViewConstantProtocol`: Defines constants used in the view model.
///
/// - Published Properties:
///   - `selectedColor`: The currently selected color. Updates will reflect in the view.
///   - `colorGroups`: A dictionary grouping colors by type for display purposes.
///
/// - Properties:
///   - `viewSettings`: Settings and constants for the view's appearance.
///   - `columns`: Defines the layout for displaying color cells in a grid.
///
/// - Methods:
///   - `colorPickerTitle`: A view displaying the title for the color picker and a color picker control.
///   - `colorsList`: A view displaying a grid of color options, grouped by type.
///   - `cell(for:)`: Returns a view for a single color cell, including selection handling and styling.
class ToolsColorsViewModel: ObservableObject, DomainViewConstantProtocol {
    typealias DomainViewConstantType = ToolsColorsViewDomain
    
    let viewSettings: ToolsColorsViewDomain = .init()
    
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
                Section(header: Text(groupKey.capitalized)
                    .font(.headline)
                    .padding(.top, .paddingSmall)) {
                        ForEach(colors, id: \.self) { color in
                            self.cell(for: color)
                        }
                    }
            }
        }
        .padding(EdgeInsets(top: .zero, leading: .paddingDefault, bottom: .paddingDefault, trailing: .paddingDefault))
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
