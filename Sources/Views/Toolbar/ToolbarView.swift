//
//  ToolbarView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI view that represents a customizable toolbar with various actions.
struct ToolbarView: CustomizableToolbarContent {
    
    @StateObject var viewModel: ToolbarViewModel
    
    /// Initializes the `ToolbarView` with a given view model.
    /// - Parameter viewModel: The view model to provide data and actions for the toolbar.
    init(viewModel: ToolbarViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some CustomizableToolbarContent {
        
        // Toolbar item for the 'Undo' action
        ToolbarItem(id: ToolbarViewDomain.Action.undo.tag, placement: .navigation) {
            viewModel.item(for: .undo)
        }
        .customizationBehavior(.disabled)
        .defaultCustomization(.visible)
        
        // Toolbar item for the 'Redo' action
        ToolbarItem(id: ToolbarViewDomain.Action.redo.tag, placement: .navigation) {
            viewModel.item(for: .redo)
        }
        .customizationBehavior(.disabled)
        .defaultCustomization(.visible)
        
        // Toolbar item for the 'Colors' action
        ToolbarItem(id: ToolbarViewDomain.Action.colors.tag, placement: .principal) {
            viewModel.item(for: .colors)
        }
        .defaultCustomization(.visible)
        
        // Toolbar item for the 'Photos' action
        ToolbarItem(id: ToolbarViewDomain.Action.photos.tag, placement: .principal) {
            viewModel.item(for: .photos)
        }
        .defaultCustomization(.visible)
        
        // Toolbar item for the 'Pictures' action
        ToolbarItem(id: ToolbarViewDomain.Action.pictures.tag, placement: .principal) {
            viewModel.item(for: .pictures)
        }
        .defaultCustomization(.visible)
        
        // Toolbar item for the 'Emojis' action
        ToolbarItem(id: ToolbarViewDomain.Action.emojis.tag, placement: .principal) {
            viewModel.item(for: .emojis)
        }
        .defaultCustomization(.visible)
        
        // Uncomment the following items if needed
        /*
        // Toolbar item for the 'Decals' action
        ToolbarItem(id: ToolbarViewDomain.Action.decals.tag, placement: .principal) {
            viewModel.item(for: .decals)
        }
        .defaultCustomization(.visible)
        
        // Toolbar item for the 'Web Resources' action
        ToolbarItem(id: ToolbarViewDomain.Action.webResources.tag, placement: .principal) {
            viewModel.item(for: .webResources)
        }
        .defaultCustomization(.visible)
        
        // Toolbar item for the 'Spacer' action
        ToolbarItem(id: ToolbarViewDomain.Action.spacer.tag, placement: .principal) {
            viewModel.item(for: .spacer)
        }
        .defaultCustomization(.visible)
        */
    }
}

#Preview("ToolbarView") {
    Rectangle()
        .toolbar(id: "preview") {
            ToolbarView(viewModel: .preview)
        }
}
