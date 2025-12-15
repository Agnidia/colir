//
//  AppliedStylesView.swift
//
//  Created on 08.11.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI view that displays the applied styles in a vertical stack.
///
/// This view uses the `AppliedStylesViewModel` environment object to manage and present
/// the styles applied to the current context. It displays a list of tags or applied styles
/// within a vertically stacked layout, with padding applied around the content.
///
/// - EnvironmentObject: `AppliedStylesViewModel` provides the data and functionality
///   needed to display the applied styles.
///
struct AppliedStylesView: View {
    /// The view model that provides the data and functionality for this view.
    @Environment(AppliedStylesViewModel.self) var viewModel

    var body: some View {
        VStack(spacing: .spacingDefault) { tagsView }
    }

    /// Creates a view that displays the tags`.
    @ViewBuilder
    var tagsView: some View {
        List {
            ForEach(views, id: \.data.id) { $0 }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: .paddingThin, leading: .paddingSmall, bottom: .zero, trailing: .paddingThin))
                .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
    }

    /// An array of custom tag views created from the `data` property.
    @MainActor
    var views: [StyleTagView] {
        viewModel.data.map { StyleTagView(data: $0) }
    }
}

#Preview("AppliedStylesView") {
    VStack {
        AppliedStylesView()
            .environment(AppliedStylesViewModel(
                state: .none,
                toolsColorsViewModel: ToolsColorsViewModel(),
                toolsPhotosViewModel: ToolsPhotosViewModel(),
                toolsPicturesViewModel: ToolsPicturesViewModel(
                    appSettings: AppSettings.preview,
                    picturesFolderManager: PicturesFolderManager(picturesDirectory: URL(string: "")!)
                ),
                toolsEmojisViewModel: ToolsEmojisViewModel()
            ))

        Divider()

        Spacer()
    }
    .frame(width: 236, height: 450)
}
