//
//  ContentView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A view that represents the main screen of the application, displaying various sections
/// based on the provided `HomeViewModel`. It includes areas for icons, applied styles, and tools.
///
/// The view is laid out in a horizontal stack, with sections for icon folders, applied styles,
/// and a customization area on the left side, and a tools view on the right side. The layout
/// adapts to the available space while keeping a fixed width for the left side.
struct HomeView: View {
    
    /// The view model that provides data and state management for the `HomeView`.
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        
#if DEBUG
        // Prints changes to help with debugging.
        let _ = Self._printChanges()
#endif
        
        HStack(alignment: .top, spacing: .zero) {
            ZStack {
                VStack {}
                    .visualEffect(material: .sidebar)
                
                VStack(alignment: .leading) {
                    
                    // Display the icon folder view provided by the view model
                    viewModel.iconFolderView()
                    
                    // Display the applied styles view provided by the view model
                    viewModel.appliedStylesView()
                    
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Display the customize folder view provided by the view model
                    viewModel.customizeFolderView()
                    
                }
            }
            .frame(minWidth: viewModel.width, maxWidth: viewModel.width, maxHeight: .infinity)
            
            Divider()
                .padding(.vertical, .paddingThin)
            
            VStack(alignment: .leading) {
                // Display the tools view provided by the view model
                toolsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .fixedSize(horizontal: false, vertical: false)
    }
    
    /// Provides the view for the selected tool.
    @ViewBuilder
    func toolsView() -> some View {
        switch viewModel.tools {
        case .colors:
            ToolsColorsView()
                .environment(viewModel.toolsColorsViewModel)
        case .photos:
            ToolsPhotosView()
                .environment(viewModel.toolsPhotosViewModel)
        case .emojis:
            ToolsEmojisView()
                .environmentObject(viewModel.toolsEmojisViewModel)
        case .decals:
            ToolsDecalsView()
        case .pictures:
            ToolsPicturesView()
                .environmentObject(viewModel.toolsPicturesViewModel)
        case .webResources:
            WebResourcesView()
                .environmentObject(viewModel.webResourcesViewModel)
        }
    }
}

#Preview("HomeView") {
    HomeView()
        .environmentObject(HomeViewModel.preview)
}
