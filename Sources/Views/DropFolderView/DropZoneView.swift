//
//  DropZoneView.swift
//
//  Created on 07.11.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI view that provides a drop zone for files, with configurable drag-and-drop functionality.
struct DropZoneView: View {
    /// The view model that provides the data and actions for the DropZoneView.
    @Environment(DropZoneViewModel.self) var viewModel

    /// Indicates whether a drop operation is pending.
    @State private var isWaitingDropping: Bool = false

    /// Indicates whether the drag is currently within the drop zone.
    @State private var isEnterZone: Bool = false

    @State private var image: ImageModel? = nil

    @State private var isProcessing: Bool = false

    var body: some View {
        Self.printDebugInfo()

        DropZoneNSView.SwiftUI(
            // Indicates whether the drop zone is enabled.
            isEnabled: true,

            // Specifies whether multiple files can be dropped at once.
            allowsMultipleDrop: false,

            // Callback to validate the files being dragged.
            // Allows drop if URLs contain folders.
            validateFiles: {
                let value: NSDragOperation = (viewModel.urlsHasFolders(urls: $0) == true) ? .copy : .init()
                return value
            },

            // Callback triggered when the drag enters or exits the drop zone.
            // Updates the view model's state and animates text.
            enterZone: { entered in
                isWaitingDropping = entered
                viewModel.animateText(hovered: entered)
                isEnterZone = entered
            },

            // Callback triggered when files are dropped.
            // Delivers the files to the view model and returns success.
            dropFiles: {
                viewModel.delivery(urls: $0)
                return true
            }
        )
        .background(content: {
            // Provides the background view from the view model.
            backgroundView
        })
        .overlay(content: {
            // Provides the overlay view from the view model.
            overlayView
        })
        .onTapGesture {
            // Handles tap gesture by opening the folder via the view model.
            viewModel.openFolder()
        }
        .onHover(perform: {
            // Animates text based on hover state.
            viewModel.animateText(hovered: $0)
            isEnterZone = $0
        })
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel(dropZoneAccessibilityLabel)
        .accessibilityHint("Click to select a folder, or drag a folder here")
        .accessibilityValue(image != nil ? "Folder selected" : "Empty")
        .accessibilityAddTraits([.isButton])
    }

    // MARK: - Accessibility

    /// Accessibility label for the drop zone
    private var dropZoneAccessibilityLabel: String {
        if image != nil {
            return "Folder drop zone with selected folder"
        }
        return "Folder drop zone"
    }

    /// The view displayed as the background of the drop zone.
    @ViewBuilder
    private var backgroundView: some View {
        ZStack {
            if isProcessing {
                EmptyView()
            }

            Rectangle()
                .fill(.dropFolderViewBackgroundActive)
                .opacity(viewModel.enterZoneAnimationBackgroundOpacity)
                .cornerRadius(.radiusThin)

            if image == nil {
                Image(systemName: "folder.badge.plus")
                    .resizable()
                    .symbolRenderingMode(.multicolor)
                    .foregroundStyle(Color.primaryText, Color.primaryText, Color.selectedView)
                    .scaleEffect(viewModel.enterZoneAnimationImageScale)
                    .animation(.spring(duration: .animationDurationDefault, bounce: 0.5), value: viewModel.enterZoneAnimationImageScale)
                    .fontWeight(.thin)
                    .aspectRatio(contentMode: .fit)
                    .padding(.paddingBig)
            } else {
                if let image = image?.previewImage {
                    Image(nsImage: image)
                        .resizable()
                        .scaleEffect(viewModel.enterZoneAnimationImageScale)
                        .animation(.spring(duration: .animationDurationDefault, bounce: 0.5), value: viewModel.enterZoneAnimationImageScale)
                        .padding(.paddingSmall)
                }
            }
        }
        .onReceive(viewModel.updatedImagePublisher) { image = $0.model }
    }

    /// The view displayed as the overlay of the drop zone.
    @ViewBuilder
    var overlayView: some View {
        let text: LocalizedStringKey? = if isWaitingDropping {
            HomeViewDomain.Localization.dropHere
        } else if isEnterZone {
            HomeViewDomain.Localization.choice
        } else if image == nil {
            HomeViewDomain.Localization.dragHere
        } else {
            nil
        }

        if let text {
            let hasFolder = image != nil
            let xOffSet: CGFloat = hasFolder ? 0 : -20
            let yOffSet: CGFloat = hasFolder ? 0 : 24

            ZStack {
                Text(text)
                    .font(.title2)
                    .scaleEffect(viewModel.enterZoneAnimationTextScale)
                    .animation(.spring(duration: .animationDurationDefault, bounce: 0.5), value: viewModel.enterZoneAnimationTextScale)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primaryText)
                    .padding(.paddingThin)
                    .background {
                        RoundedRectangle(cornerRadius: .radiusSmall)
                            .fill(.primaryBackground)
                            .scaleEffect(viewModel.enterZoneAnimationTextScale)
                            .animation(.spring(duration: .animationDurationDefault, bounce: 0.5), value: viewModel.enterZoneAnimationTextScale)
                    }
            }
            .offset(x: xOffSet, y: yOffSet)
            .padding(.paddingLarge)
        }
    }
}

#Preview("ToolsColorsView") {
    DropZoneView()
        .environment(DropZoneViewModel(fileClosure: { _ in }, updateStateClosure: { _ in }))
        .frame(width: 300, height: 300)
        .padding(.paddingDefault)
}
