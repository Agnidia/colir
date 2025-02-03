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
    
    private enum ButtonsFocusable: Hashable {
        case subscribe
        case tips1
        case tips2
        case restore
        case close
    }

    @FocusState private var elementFocus: ButtonsFocusable?
    
    @Environment(AppStoreViewModel.self) var viewModel
    
    @State private var selectedProduct: AppProduct?
    
    /// Published property indicating whether an overlay (e.g., progress indicator) should be displayed.
    @State private(set) var displayOverlay = false
    
    var body: some View {
        VStack(spacing: .spacingHeight) {
            HStack {
                closeButton
                
                Spacer()
                
                restoreButton
            }
            
            titleSubscription
            
            subscriptionsList
            
            titleInAppPurchase
            
            inAppPurchasesList
        }
        .onAppear(perform: {
            Task(operation: setup)
        })
        .padding(.paddingBig)
        .padding([.horizontal, .bottom], .paddingCompact)
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
    
    private func setup() {
        elementFocus = .subscribe
    }
    
    /// List of subscription products.
    @ViewBuilder
    var subscriptionsList: some View {
        ListView(for: AppProduct.subscriptions, ids: [.subscribe])
    }
    
    /// List of in-app purchase products.
    @ViewBuilder
    var inAppPurchasesList: some View {
        ListView(for: AppProduct.inAppPurchases, ids: [.tips1, .tips2])
    }
    
    /// Creates a grid view for displaying a list of products.
    ///
    /// - Parameter products: The list of products to be displayed.
    /// - Returns: A `LazyHGrid` containing buttons for each product.
    @ViewBuilder
    private func ListView(for products: [AppProduct], ids: [ButtonsFocusable]) -> some View {
        LazyHGrid(rows: viewModel.rows, alignment: .center) {
            ForEach(Array(zip(products, ids)), id: \.0) { (item, id) in
                Button { purchase(item: item) } label: {
                    let info = try? viewModel.appStoreService.info(for: item)
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
                .focused($elementFocus, equals: id)
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
    
    private func dismissOverlay() {
        displayOverlay = false
    }
    
    /// Title for the subscriptions section.
    @ViewBuilder
    var titleSubscription: some View {
        Text(AppStoreViewDomain.Localization.titleSubscription)
            .font(.title)
    }
    
    /// Title for the in-app purchases section.
    @ViewBuilder
    var titleInAppPurchase: some View {
        Text(AppStoreViewDomain.Localization.titleInAppPurchase)
            .font(.title)
            .padding(.top, .paddingThin)
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
            Image(systemName: "arrow.counterclockwise")
                .font(.title)
                .padding(.vertical, .paddingSmall)
        }
        .buttonStyle(.borderless)
        .focused($elementFocus, equals: .restore)
    }
    
    /// Button for closing the App Store view.
    @ViewBuilder
    var closeButton: some View {
        Button(action: viewModel.completionHandler) {
            Image(systemName: "xmark.circle")
                .font(.title)
                .padding(.vertical, .paddingSmall)
        }
        .buttonStyle(.borderless)
        .focused($elementFocus, equals: .close)
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
            .padding()
    }
}
