//
//  ToolbarView.swift
//
//  Created on 15.09.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI view that represents a customizable toolbar with various actions.
struct ToolbarView: CustomizableToolbarContent {
    @StateObject var viewModel: ToolbarViewModel

    /// The current tool action selected.
    @State private var currentToolAction = ToolbarView.ToolbarViewDomain.Action.colors

    var body: some CustomizableToolbarContent {
        // Toolbar item for the 'Undo' action
        ToolbarItem(id: ToolbarViewDomain.Action.undo.tag, placement: .navigation) {
            item(for: .undo)
        }
        .customizationBehavior(.disabled)
        .defaultCustomization(.visible)

        // Toolbar item for the 'Redo' action
        ToolbarItem(id: ToolbarViewDomain.Action.redo.tag, placement: .navigation) {
            item(for: .redo)
        }
        .customizationBehavior(.disabled)
        .defaultCustomization(.visible)

        // Toolbar item for the 'Colors' action
        ToolbarItem(id: ToolbarViewDomain.Action.colors.tag, placement: .principal) {
            item(for: .colors)
        }
        .defaultCustomization(.visible)

        // Toolbar item for the 'Photos' action
        ToolbarItem(id: ToolbarViewDomain.Action.photos.tag, placement: .principal) {
            item(for: .photos)
        }
        .defaultCustomization(.visible)

        // Toolbar item for the 'Pictures' action
        ToolbarItem(id: ToolbarViewDomain.Action.pictures.tag, placement: .principal) {
            item(for: .pictures)
        }
        .defaultCustomization(.visible)

        // Toolbar item for the 'Emojis' action
        ToolbarItem(id: ToolbarViewDomain.Action.emojis.tag, placement: .principal) {
            item(for: .emojis)
        }
        .defaultCustomization(.visible)

        // Toolbar item for the 'Emojis' action
        ToolbarItem(id: ToolbarViewDomain.Action.tips.tag, placement: .confirmationAction) {
            item(for: .tips)
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

    /// Constructs a toolbar item view for a given action.
    /// - Parameter action: The action for which to create a toolbar item.
    /// - Returns: A SwiftUI view for the toolbar item.
    @ViewBuilder
    func item(for action: ToolbarView.ToolbarViewDomain.Action) -> some View {
        switch action {
        case .colors, .photos, .emojis, .decals, .pictures, .webResources:
            Button {
                currentToolAction = action
            } label: {
                Label(action.title, systemImage: action.icon)
                    .font(.title3)
            }
            .background(RoundedRectangle(cornerRadius: .radiusDefault)
                .fill(currentToolAction == action ? Color.accent.opacity(0.4) : .clear))
            .help(action.helpTitle)
        case .tips:
            Button {
                viewModel.perform(action)
            } label: {
                Label(action.title, systemImage: action.icon)
                    .font(.title3)
                    .foregroundStyle(viewModel.hasTipped ? .green : .primary)
            }
            .background(RoundedRectangle(cornerRadius: .radiusDefault)
                .fill(currentToolAction == action ? Color.accent.opacity(0.4) : .clear))
            .help(action.helpTitle)
        case .spacer:
            Spacer()
        case .undo:
            HStack {
                Spacer()
                Button { viewModel.perform(action) } label: {
                    Label(action.title, systemImage: action.icon)
                        .font(.title3)
                }
                .help(action.helpTitle)
                .disabled(viewModel.undoManager.canUndo == false)
            }
        // .frame(width: 84)
        case .redo:
            HStack {
                Button { viewModel.perform(action) } label: {
                    Label(action.title, systemImage: action.icon)
                        .font(.title3)
                }
                .help(action.helpTitle)
                .disabled(viewModel.undoManager.canRedo == false)

                Spacer()

//                Divider()
//                    .background(Color.primaryDivider.opacity(0.01))
            }
            // .frame(width: 64)
        }
    }
}

#Preview("ToolbarView") {
    Rectangle()
        .toolbar(id: "preview") {
            ToolbarView(viewModel: .preview)
        }
}
