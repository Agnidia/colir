//
//  ToolbarView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct ToolbarView: CustomizableToolbarContent {
    
    @StateObject var viewModel: ToolbarViewModel
    
    init(viewModel: ToolbarViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some CustomizableToolbarContent {
        
        ToolbarItem(id: ToolbarViewDomain.Action.undo.tag, placement: .navigation) {
            viewModel.item(for: .undo)
        }
        .customizationBehavior(.disabled)
        .defaultCustomization(.visible)
        
        ToolbarItem(id: ToolbarViewDomain.Action.redo.tag, placement: .navigation) {
            viewModel.item(for: .redo)
        }
        .customizationBehavior(.disabled)
        .defaultCustomization(.visible)
        
        ToolbarItem(id: ToolbarViewDomain.Action.colors.tag, placement: .principal) {
            viewModel.item(for: .colors)
        }
        .defaultCustomization(.visible)
        
        ToolbarItem(id: ToolbarViewDomain.Action.photos.tag, placement: .principal) {
            viewModel.item(for: .photos)
        }
        .defaultCustomization(.visible)
        
        ToolbarItem(id: ToolbarViewDomain.Action.pictures.tag, placement: .principal) {
            viewModel.item(for: .pictures)
        }
        .defaultCustomization(.visible)
        
        ToolbarItem(id: ToolbarViewDomain.Action.emojis.tag, placement: .principal) {
            viewModel.item(for: .emojis)
        }
        .defaultCustomization(.visible)
        
        ToolbarItem(id: ToolbarViewDomain.Action.decals.tag, placement: .principal) {
            viewModel.item(for: .decals)
        }
        .defaultCustomization(.visible)
        
        ToolbarItem(id: ToolbarViewDomain.Action.webResources.tag, placement: .principal) {
            viewModel.item(for: .webResources)
        }
        .defaultCustomization(.visible)
        
        ToolbarItem(id: ToolbarViewDomain.Action.spacer.tag, placement: .principal) {
            viewModel.item(for: .spacer)
        }
        .defaultCustomization(.visible)
    }
}

#Preview("ToolbarView") {
    Rectangle()
        .toolbar(id: "preview") {
            ToolbarView(viewModel: .preview)
        }
}
