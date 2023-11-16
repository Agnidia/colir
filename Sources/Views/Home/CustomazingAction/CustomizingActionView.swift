//
//  CustomizingActionView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
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
            .environmentObject(CustomizingActionViewModel(state: .none, actionClosure: {}))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .ready, actionClosure: {}))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .preview, actionClosure: {}))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .processing(value: 30), actionClosure: {}))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .error, actionClosure: {}))
        
        Divider()
        Spacer()
    }
    .frame(width: 236, height: 450)
}
