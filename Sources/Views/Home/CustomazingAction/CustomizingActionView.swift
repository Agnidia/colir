//
//  CustomizingActionView.swift
//  colir
//
//  Created by Vitalii P on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct CustomizingActionView: View {
    @EnvironmentObject var viewModel: CustomizingActionViewModel
    
    var body: some View {
        VStack(spacing: viewModel.viewSettings.spacing) {
            
            viewModel.titleText
            
            viewModel.descriptionText
            
            viewModel.actionButton
        }
    }
}

#Preview("CustomizingActionView") {
    CustomizingActionView()
        .environmentObject(CustomizingActionViewModel())
}
