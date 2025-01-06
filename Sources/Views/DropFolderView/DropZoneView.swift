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
    @EnvironmentObject var viewModel: DropZoneViewModel
    
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
            validateFiles: { urls in
                let value: NSDragOperation = (viewModel.urlsHasFolders(urls: urls) == true) ? .copy : .init()
                return value
            },
            
            // Callback triggered when the drag enters or exits the drop zone.
            // Updates the view model's state and animates text.
            enterZone: { entered in
                viewModel.isWaitingDropping = entered
                viewModel.animateText(hovered: entered)
            },
            
            // Callback triggered when files are dropped.
            // Delivers the files to the view model and returns success.
            dropFiles: { urls in
                viewModel.delivery(urls: urls)
                return true
            }
        )
        .background(content: {
            // Provides the background view from the view model.
            viewModel.backgroundView
        })
        .overlay(content: {
            // Provides the overlay view from the view model.
            viewModel.overlayView
        })
        .onTapGesture {
            // Handles tap gesture by opening the folder via the view model.
            viewModel.openFolder()
        }
        .onHover(perform: { hovered in
            // Animates text based on hover state.
            viewModel.animateText(hovered: hovered)
        })
    }
}

#Preview("ToolsColorsView") {
    DropZoneView()
        .environmentObject(DropZoneViewModel(fileClosure: {_ in}, updateStateClosure: {_ in}))
        .frame(width: 300, height: 300)
        .padding(.paddingDefault)
}
