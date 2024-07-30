//
//  AppStoreViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 13.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

/// ViewModel for managing and displaying App Store related views, including subscriptions and in-app purchases.
///
/// This view model interacts with `AppStoreProtocol` for handling purchases and `AppSettingsProtocol` for updating application settings.
/// It manages the state of the UI, including displaying overlays and handling user interactions for purchasing and restoring products.
final class AppStoreViewModel: ObservableObject, DomainViewConstantProtocol {
    
    // MARK: - DomainViewConstantProtocol
    /// Type alias for domain-specific view constants.
    typealias DomainViewConstantType = AppStoreViewDomain
    
    /// View settings and constants for the App Store view.
    var viewSettings: DomainViewConstantType = .init()
    
    // MARK: - Properties
    
    /// Service for interacting with the App Store.
    private let appStoreService: AppStoreProtocol
    
    /// Application settings for managing export counts and other configurations.
    private var appSettings: AppSettingsProtocol
    
    /// Closure to be called when the view is closed or when a specific action is completed.
    private let completionHandler: Commons.EmptyClosure
    
    /// Published property indicating whether an overlay (e.g., progress indicator) should be displayed.
    @Published private(set) var displayOverlay = false
    
    // MARK: - Initialization
    
    /// Initializes the view model with the given services and completion handler.
    ///
    /// - Parameters:
    ///   - appStoreService: The service responsible for handling App Store purchases.
    ///   - appSettings: The application settings for managing configurations.
    ///   - completion: A closure to be executed upon completion of an action.
    init(appStoreService: AppStoreProtocol, appSettings: AppSettingsProtocol, completion: @escaping Commons.EmptyClosure) {
        self.appSettings = appSettings
        self.appStoreService = appStoreService
        self.completionHandler = completion
    }
    
    // MARK: - Views
    
    /// Title for the subscriptions section.
    @ViewBuilder
    var titleSubscription: some View {
        Text(DomainViewConstantType.Localization.titleSubscription)
            .font(.title)
            .padding(.top, .paddingLarge)
    }
    
    /// Size of the buttons in the grid.
    private static var buttonSize: CGFloat = 150
    
    /// Layout for the grid items.
    private let rows = [
        GridItem(.adaptive(minimum: buttonSize, maximum: buttonSize))
    ]
    
    /// List of subscription products.
    @ViewBuilder
    var subscriptionsList: some View {
        ListView(for: AppProduct.subscriptions)
    }
    
    /// Title for the in-app purchases section.
    @ViewBuilder
    var titleInAppPurchase: some View {
        Text(DomainViewConstantType.Localization.titleInAppPurchase)
            .font(.title)
            .padding(.top, .paddingDefault)
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
        LazyHGrid(rows: rows, alignment: .center) {
            ForEach(products, id: \.self) { item in
                Button {
                    self.displayOverlay = true
                    Task {
                        do {
                            let result = try await self.appStoreService.purchase(item)
                            self.process(purchase: result)
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        Task { @MainActor in
                            self.displayOverlay = false
                        }
                    }
                } label: {
                    let info = try? self.appStoreService.info(for: item)
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
    
    /// Button for restoring previous purchases.
    @ViewBuilder
    var restoreButton: some View {
        Button {
            Task {
                do {
                    try await self.appStoreService.syncStoreData()
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
    
    /// Button for closing the App Store view.
    @ViewBuilder
    var closeButton: some View {
        Button { [weak self] in
            self?.completionHandler()
        } label: {
            Text("Done")
                .padding(.init(top: .paddingSmall, leading: .zero, bottom: .paddingSmall, trailing: .zero))
                .frame(width: AppStoreViewModel.buttonSize)
        }
        .buttonStyle(.accent)
    }
    
    // MARK: - Methods
    
    /// Processes the result of a purchase attempt.
    ///
    /// - Parameter purchase: The result of the purchase attempt.
    private func process(purchase: PurchaseResult) {
        switch purchase {
        case .success(let product):
            handleSuccess(for: product)
            Task { @MainActor in
                completionHandler()
            }
        case .userCancelled:
            // Handle user cancellation if needed
            break
        case .pending:
            // Handle pending state if needed
            break
        }
    }
    
    /// Handles successful purchase and updates application settings.
    ///
    /// - Parameter product: The product that was successfully purchased.
    private func handleSuccess(for product: AppProduct) {
        switch product {
        case .add1Folder: addExports(count: 1)
        case .add5Folder: addExports(count: 5)
        case .add15Folder: addExports(count: 15)
        case .fullAccessLifetime, .fullAccess1Month, .fullAccessYear:
            // Handle these cases if needed
            break
        }
    }
    
    /// Updates the export count based on the purchased amount.
    ///
    /// - Parameter count: The number of additional exports to add.
    private func addExports(count: Int) {
        let exportCount = (Int(appSettings.exportCount.value) ?? .zero) + count
        appSettings.exportCount = CryptoModel(value: "\(exportCount)")
    }
}
