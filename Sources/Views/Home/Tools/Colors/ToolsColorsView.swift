//
//  ToolsColorsView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 31.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct ToolsColorsView: View {
    
    @EnvironmentObject var viewModel: ToolsColorsViewModel
    
    var body: some View {
        ScrollView {
            viewModel.colorPickerTitle
            
            viewModel.colorsList
        }
    }
}

#Preview("ToolsColorsView") {
    ToolsColorsView()
        .environmentObject(ToolsColorsViewModel.preview)
}
