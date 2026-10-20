//
//  PermissionsOverlayView.swift
//
//  Created on 30.10.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import SwiftUI

/// A view that displays an overlay with permissions-related information.
///
/// `PermissionsOverlayView` shows a background view, a title, a description, and an action button.
/// This view is typically used to prompt users to grant necessary permissions for the app.
///
/// - Example Usage:
///   ```swift
///   PermissionsOverlayView()
///       .environmentObject(PermissionsOverlayViewModel(title: "Title", description: "description", url: URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!))
///   ```
struct PermissionsOverlayView: View {
    @EnvironmentObject var viewModel: PermissionsOverlayViewModel

    var body: some View {
        ZStack {
            // Background view, often used to dim the screen or provide a backdrop.
            viewModel.backgroundView

            VStack(spacing: viewModel.viewSettings.spacing) {
                // Title text for the overlay.
                viewModel.titleText

                // Description text providing additional information.
                viewModel.descriptionText

                // Action button for taking the necessary steps (e.g., opening system preferences).
                viewModel.actionButton
            }
        }
    }
}

#Preview("PermissionsOverlayView") {
    PermissionsOverlayView()
        .environmentObject(PermissionsOverlayViewModel(title: "Title", description: "description", url: URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!))
}
