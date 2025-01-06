//
//  AppStoreView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 13.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI view that presents the app store interface for subscriptions and in-app purchases.
struct AppStoreView: View {
    @Environment(AppStoreViewModel.self) var viewModel
    
    @State private var selectedProduct: AppProduct?
    
    /// Published property indicating whether an overlay (e.g., progress indicator) should be displayed.
    @State private(set) var displayOverlay = false
    
    var body: some View {
        VStack(spacing: .spacingHeight) {
            
            viewModel.titleSubscription
            
            subscriptionsList
            
            viewModel.titleInAppPurchase
            
            inAppPurchasesList
            
            HStack {
                restoreButton
                
                Spacer()
                
                viewModel.closeButton
            }
            .padding(.init(top: .paddingDefault, leading: .zero, bottom: .zero, trailing: .zero))
            
            Spacer()
        }
        .padding(.horizontal, .paddingLarge)
        .overlay {
            if displayOverlay {
                ZStack {
                    Rectangle()
                        .fill(.background.opacity(0.8))
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .edgesIgnoringSafeArea(.all) // Ensure overlay covers the entire view
            }
        }
    }
    
    /// List of subscription products.
    @ViewBuilder
    var subscriptionsList: some View {
        ListView(for: AppProduct.subscriptions)
    }
    
    /// List of in-app purchase products.
    @ViewBuilder
    var inAppPurchasesList: some View {
        ListView(for: AppProduct.inAppPurchases)
    }
    
    /// Creates a grid view for displaying a list of products.
    ///
    /// - Parameter products: The list of products to be displayed.
    /// - Returns: A `LazyHGrid` containing buttons for each product.
    @ViewBuilder
    private func ListView(for products: [AppProduct]) -> some View {
        LazyHGrid(rows: viewModel.rows, alignment: .center) {
            ForEach(products, id: \.self) { item in
                Button { purchase(item: item) } label: {
                    let info = try? self.viewModel.appStoreService.info(for: item)
                    VStack {
                        Text(info?.name ?? "")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        Text(info?.description ?? "")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.paddingThin)
                        Spacer()
                        Text(info?.price ?? "")
                            .font(.body)
                    }
                    .padding(.paddingDefault)
                    .frame(width: AppStoreViewModel.buttonSize, height: AppStoreViewModel.buttonSize)
                }
                .buttonStyle(.appStore)
            }
        }
        .frame(height: AppStoreViewModel.buttonSize)
    }
    
    
    private func purchase(item: AppProduct) {
        selectedProduct = item
        
        displayOverlay = true
        
        Task(operation: purchaseSelectedProduct)
    }
    
    private func purchaseSelectedProduct() async {
        
        guard let selectedProduct else { return }
        
        do {
            let result = try await viewModel.appStoreService.purchase(selectedProduct)
            viewModel.process(purchase: result)
        } catch {
            print(error.localizedDescription)
        }
        
        Task(operation: dismissOverlay)
    }
    
    @MainActor
    private func dismissOverlay() {
        displayOverlay = false
    }
    
    /// Button for restoring previous purchases.
    @ViewBuilder
    var restoreButton: some View {
        Button {
            Task { [viewModel] in
                do {
                    try await viewModel.appStoreService.syncStoreData()
                } catch {
                    print("Sync error: \(error.localizedDescription)")
                }
            }
        } label: {
            Text("Restore")
                .padding(.init(top: .paddingSmall, leading: .zero, bottom: .paddingSmall, trailing: .zero))
                .frame(width: AppStoreViewModel.buttonSize)
        }
        .buttonStyle(.accent)
    }
}

#Preview("AppStoreView") {
    VStack {
        AppStoreView()
            .environment(AppStoreViewModel(
                appStoreService: AppStorePreview(),
                appSettings: AppSettings.preview,
                completion: {}
            ))
    }
    .frame(width: 236, height: 450)
}
