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
        VStack(spacing:0) {
            
            viewModel.progressView
            
            viewModel.actionButton
        }
        .padding(.horizontal, 16)
    }
}

#Preview("AppliedStylesView") {
    VStack {
        AppliedStylesView()
            .environmentObject(AppliedStylesViewModel(state: .none))
        
        Divider()
        
        
        Spacer()
    }
    .frame(width: 236, height: 450)
}
