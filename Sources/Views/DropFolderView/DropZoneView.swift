//
//  DropZoneView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
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
    
    @State private var image: ImageDto = .init()
    
    var body: some View {
#if DEBUG
        // Prints changes for debug purposes.
        let _ = Self._printChanges()
#endif
        
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
    }
    
    /// The view displayed as the background of the drop zone.
    @ViewBuilder
    private var backgroundView: some View {
        ZStack {
            Rectangle()
                .fill(.dropFolderViewBackgroundActive)
                .opacity(viewModel.enterZoneAnimationBackgroundOpacity)
                .cornerRadius(.radiusThin)
            
            if image.state == .none {
                Image(systemName: "folder.badge.plus")
                    .resizable()
                    .symbolRenderingMode(.multicolor)
                    .scaleEffect(viewModel.enterZoneAnimationImageScale)
                    .animation(.spring(duration: .animationDurationDefault, bounce: 0.5), value: viewModel.enterZoneAnimationImageScale)
                    .fontWeight(.thin)
                    .aspectRatio(contentMode: .fit)
                    .padding(.paddingBig)
            } else {
                image.preview
                    .scaleEffect(viewModel.enterZoneAnimationImageScale)
                    .animation(.spring(duration: .animationDurationDefault, bounce: 0.5), value: viewModel.enterZoneAnimationImageScale)
                    .padding(.paddingSmall)
            }
        }
        .onReceive(viewModel.updatedImagePublisher) { image = $0 }
    }
    
    /// The text overlay displayed on top of the drop zone.
    private var overlayText: LocalizedStringKey {
        var text = HomeViewDomain.Localization.dragHere
        if isEnterZone {
            text = HomeViewDomain.Localization.choice
        }
        if isWaitingDropping {
            text = HomeViewDomain.Localization.dropHere
        }
        
        return text
    }
    
    /// The view displayed as the overlay of the drop zone.
    @ViewBuilder
    var overlayView: some View {
        let text: LocalizedStringKey? = if isWaitingDropping {
            HomeViewDomain.Localization.dropHere
        } else if isEnterZone {
            HomeViewDomain.Localization.choice
        } else if image.state == .none {
            HomeViewDomain.Localization.dragHere
        } else {
            nil
        }
        
        if let text {
            
            let hasFolder = image.state != .none
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
                    
                    }
            }
            .offset(x: xOffSet, y: yOffSet)
            .padding(.paddingLarge)
        }
    }
}

#Preview("ToolsColorsView") {
    DropZoneView()
        .environment(DropZoneViewModel(fileClosure: {_ in}, updateStateClosure: {_ in}))
        .frame(width: 300, height: 300)
        .padding(.paddingDefault)
}
