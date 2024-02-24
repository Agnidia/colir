//
//  AppStoreView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 13.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct AppStoreView: View {
    @EnvironmentObject var viewModel: AppStoreViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            
            viewModel.titleSubscription
            
            viewModel.subscriptionsList
            
            viewModel.titleInAppPurchase
            
            viewModel.inAppPurchasesList
            
            HStack {
                viewModel.restoreButton
                
                Spacer()
                
                viewModel.closeButton
            }
            .padding(.init(top: 16, leading: 0, bottom: 0, trailing: 0))
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .overlay {
            if viewModel.displayOverlay {
                ZStack {
                    Rectangle()
                        .fill(.background.opacity(0.8))
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
        }
    }
}

#Preview("AppStoreView") {
    VStack {
        AppStoreView()
            .environmentObject(AppStoreViewModel(appStoreService: AppStorePreview(), appSettings: AppSettings.preview, completion: {}))
    }
    .frame(width: 236, height: 450)
}
