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
@Observable
final class AppStoreViewModel: DomainViewConstantProtocol, @unchecked Sendable {
    
    // MARK: - DomainViewConstantProtocol
    /// Type alias for domain-specific view constants.
    typealias DomainViewConstantType = AppStoreViewDomain
    
    /// View settings and constants for the App Store view.
    var viewSettings: DomainViewConstantType = .init()
    
    // MARK: - Properties
    
    /// Service for interacting with the App Store.
    let appStoreService: AppStoreProtocol
    
    /// Application settings for managing export counts and other configurations.
    private var appSettings: AppSettingsProtocol
    
    /// Closure to be called when the view is closed or when a specific action is completed.
    private let completionHandler: Commons.EmptyClosure
    
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
    @MainActor
    @ViewBuilder
    var titleSubscription: some View {
        Text(DomainViewConstantType.Localization.titleSubscription)
            .font(.title)
            .padding(.top, .paddingLarge)
    }
    
    /// Size of the buttons in the grid.
    static var buttonSize: CGFloat { 150 }
    
    /// Layout for the grid items.
    let rows = [
        GridItem(.adaptive(minimum: buttonSize, maximum: buttonSize))
    ]
    
    /// Title for the in-app purchases section.
    @MainActor
    @ViewBuilder
    var titleInAppPurchase: some View {
        Text(DomainViewConstantType.Localization.titleInAppPurchase)
            .font(.title)
            .padding(.top, .paddingDefault)
    }
    
    /// Button for closing the App Store view.
    @MainActor
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
    func process(purchase: PurchaseResult) {
        switch purchase {
        case .success(let product):
            handleSuccess(for: product)
            completionHandler()
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
