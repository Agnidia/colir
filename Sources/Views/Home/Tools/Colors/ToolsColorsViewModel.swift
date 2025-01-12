//
//  ToolsColorsViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 18.09.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons
import Combine

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
@Observable
final class ToolsColorsViewModel: DomainViewConstantProtocol {
    typealias DomainViewConstantType = ToolsColorsViewDomain
    
    let viewSettings: ToolsColorsViewDomain = .init()
    
    let cellWidth: CGFloat = 128
    let cellHeight: CGFloat = 48
    
    var cellCornerRadius: CGFloat {
        viewSettings.cornerRadius ?? .radiusThin
    }
    
    var selectedColor: NSColor? = nil
    private(set) var selectedColorPublisher: PassthroughSubject<NSColor?, Never> = .init()
}

extension ToolsColorsViewModel {
    static var preview: ToolsColorsViewModel {
        ToolsColorsViewModel()
    }
}
