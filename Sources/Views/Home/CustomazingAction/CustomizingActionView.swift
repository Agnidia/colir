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
        VStack(spacing:0) {
            
            viewModel.progressView
            
            viewModel.actionButton
        }
        .padding(.horizontal, 16)
    }
}

#Preview("CustomizingActionView") {
    VStack {
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .none))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .ready))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .preview))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .processing(value: 30)))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .error))
        
        Divider()
        Spacer()
    }
    .frame(width: 236, height: 450)
}
