//
//  HomeView.swift
//
//  Created on 15.09.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftCommons
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
        Self.printDebugInfo()

        HStack(alignment: .top, spacing: .zero) {
            VStack(alignment: .leading) {
                // Display the icon folder view provided by the view model
                iconFolderView()

                // Display the applied styles view provided by the view model
                appliedStylesView()

                // Display the customize folder view provided by the view model
                customizeFolderView()
            }
            .frame(minWidth: viewModel.dropZoneSize, maxWidth: viewModel.dropZoneSize, maxHeight: .infinity)
            .clipped()

            VStack(alignment: .leading) {
                // Display the tools view provided by the view model
                toolsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .fixedSize(horizontal: false, vertical: false)
        .background {
            Color.primaryBackground
        }
    }

    /// Provides the view for the icon folder.
    @ViewBuilder
    private func iconFolderView() -> some View {
        DropZoneView()
            .environment(viewModel.dropZoneViewModel)
            .frame(width: viewModel.dropZoneSize, height: viewModel.dropZoneSize)
            .modifier(Shake(animatableData: CGFloat(viewModel.wrongAttempt)))
            .background(
                Rectangle()
                    .fill(.shadow(.inner(radius: 12, x: -8, y: -8)))
                    .foregroundStyle(.primaryBackground)
            )
            .clipShape(.rect(bottomTrailingRadius: 24))
    }

    /// Provides the view for the selected tool.
    @ViewBuilder
    private func toolsView() -> some View {
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

    /// Provides the view for the applied styles.
    @ViewBuilder
    private func appliedStylesView() -> some View {
        AppliedStylesView()
            .environment(viewModel.appliedStylesViewModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(x: -.paddingHeight)
    }

    /// Provides the view for the customization folder.
    @ViewBuilder
    private func customizeFolderView() -> some View {
        CustomizingActionView()
            .environment(viewModel.customizingActionViewModel)
            .frame(maxWidth: .infinity)
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.showingExportAlert },
                set: { newState in
                    viewModel.showingExportAlert = newState
                }
            )) {
                Alert(title: Text(HomeViewDomain.Localization.alertPurchaseTitle),
                      message: Text(HomeViewDomain.Localization.alertPurchaseDescription),
                      primaryButton: .default(Text(HomeViewDomain.Localization.alertPurchaseAction), action: {
                          viewModel.showingAppStoreSheet.toggle()
                      }), secondaryButton: .cancel(Text(HomeViewDomain.Localization.alertPurchaseCancel)))
            }
            .sheet(isPresented: Binding<Bool>(
                get: { viewModel.showingAppStoreSheet },
                set: { newState in
                    viewModel.showingAppStoreSheet = newState
                }
            )) {
                AppStoreView()
                    .environment(viewModel.appStoreViewModel)
            }
    }
}

#Preview("HomeView") {
    HomeView()
        .environmentObject(HomeViewModel.preview)
}
