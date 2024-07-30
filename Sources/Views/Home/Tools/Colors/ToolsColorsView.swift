//
//  ToolsColorsView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 31.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

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
    
    @EnvironmentObject var viewModel: ToolsColorsViewModel
    
    var body: some View {
        ScrollView {
            viewModel.colorPickerTitle
            
            viewModel.colorsList
        }
    }
}

#Preview("ToolsColorsView") {
    ToolsColorsView()
        .environmentObject(ToolsColorsViewModel.preview)
}
