//
//  AppliedStylesView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct AppliedStylesView: View {
    @EnvironmentObject var viewModel: AppliedStylesViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            
            viewModel.tagsView
        }
        .padding(.init(top: .paddingThin, leading: .paddingHeight, bottom: .paddingThin, trailing: .paddingDefault))
    }
}

#Preview("AppliedStylesView") {
    VStack {
        AppliedStylesView()
            .environmentObject(AppliedStylesViewModel(state: .none, toolsColorsViewModel: ToolsColorsViewModel(), toolsPhotosViewModel: ToolsPhotosViewModel(), toolsPicturesViewModel: ToolsPicturesViewModel(appSettings: AppSettings.preview, picturesFolderManager: PicturesFolderManager.init(picturesDirectory: URL(string: "")!)), toolsEmojisViewModel: ToolsEmojisViewModel()))
        
        Divider()
        
        Spacer()
    }
    .frame(width: 236, height: 450)
}
