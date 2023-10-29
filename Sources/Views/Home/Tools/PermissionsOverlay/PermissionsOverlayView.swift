//
//  PermissionsOverlayView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 15.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct PermissionsOverlayView: View {
    @EnvironmentObject var viewModel: PermissionsOverlayViewModel
    
    var body: some View {
        ZStack {
            viewModel.backgroundView
            
            VStack(spacing: viewModel.viewSettings.spacing) {
                
                viewModel.titleText
                
                viewModel.descriptionText
                
                viewModel.actionButton
            }
        }
    }
}

#Preview("PermissionsOverlayView") {
    PermissionsOverlayView()
        .environmentObject(PermissionsOverlayViewModel(title: "Title", description: "description", url: URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!))
}
