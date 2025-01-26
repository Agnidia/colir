//
//  AppliedStylesView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
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
    @EnvironmentObject var viewModel: AppliedStylesViewModel
    
    var body: some View {
        VStack(spacing: .zero) { viewModel.tagsView }
            .padding(.init(top: .paddingThin, leading: .paddingHeight, bottom: .paddingThin, trailing: .paddingDefault))
    }
}

#Preview("AppliedStylesView") {
    VStack {
        AppliedStylesView()
            .environmentObject(AppliedStylesViewModel(
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
