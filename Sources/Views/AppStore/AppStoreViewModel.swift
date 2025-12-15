//
//  AppStoreViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 13.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftCommons
import SwiftUI

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
    let completionHandler: Commons.EmptyClosure

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
        completionHandler = completion
    }

    // MARK: - Views

    /// Size of the buttons in the grid.
    static var buttonSize: CGFloat { 150 }

    /// Layout for the grid items.
    let rows = [
        GridItem(.adaptive(minimum: buttonSize, maximum: buttonSize)),
    ]

    // MARK: - Methods

    /// Processes the result of a purchase attempt.
    ///
    /// - Parameter purchase: The result of the purchase attempt.
    func process(purchase: PurchaseResult) {
        switch purchase {
        case let .success(product):
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
    private func handleSuccess(for _: AppProduct) {
        appSettings.tipped = CryptoModel(value: "1")
    }
}
