//
//  AppStoreService.swift
//
//  Created on 14.11.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Foundation
import StoreHelper
import StoreKit

/// Represents the different in-app products available for purchase.
public enum AppProduct: String, CaseIterable, Equatable, Sendable {
    case smallTips = "com.igrsoft.colir.small.tips1.subs"
    case middleTips = "com.igrsoft.colir.middle.tips.inapp"
    case bigTips = "com.igrsoft.colir.big.tips.inapp"

    /// The unique identifier of the product.
    public var id: String { rawValue }

    /// A list of in-app purchase products.
    static var inAppPurchases: [AppProduct] {
        [.middleTips, .bigTips]
    }

    /// A list of subscription products.
    static var subscriptions: [AppProduct] {
        [.smallTips]
    }
}

/// Contains information about an App Store product.
public struct AppStoreProductInfo: Sendable {
    let name: String
    let description: String
    let price: String
}

/// Represents the possible results of a purchase attempt.
public enum PurchaseResult: Sendable {
    /// The purchase succeeded with a `Transaction`.
    case success(AppProduct)
    /// The user cancelled the purchase.
    case userCancelled
    /// The purchase is pending some user action.
    ///
    /// These purchases may succeed in the future, and the resulting `Transaction` will be
    /// delivered via `Transaction.updates`.
    case pending
}

/// A protocol defining the required functionalities for interacting with the App Store.
@MainActor
public protocol AppStoreProtocol {
    /// Synchronizes store data with the App Store.
    func syncStoreData() async throws

    /// Initiates the purchase of a specified product.
    /// - Parameter product: The product to be purchased.
    /// - Returns: The result of the purchase attempt.
    func purchase(_ product: AppProduct) async throws -> PurchaseResult

    /// Retrieves information for a specified product.
    /// - Parameter product: The product to retrieve information for.
    /// - Returns: Information about the product.
    func info(for product: AppProduct) throws -> AppStoreProductInfo

    /// Indicates whether the user has full access.
    var hasFullAccess: Bool { get }
}

/// Represents errors that can occur within the `AppStoreService`.
enum AppStoreServiceError: Error {
    case missedProduct
    case storeNotStarted
}

/// A service class that handles interactions with the App Store using StoreHelper.
@MainActor
final class AppStoreService: AppStoreProtocol {
    private let storeHelper: StoreHelper

    private var log: LogProtocol

    /// Initializes the AppStoreService.
    /// - Parameters:
    ///   - storeHelper: The StoreHelper instance to use (defaults to shared instance).
    ///   - logger: An optional logger for logging messages.
    init(storeHelper: StoreHelper = StoreHelper(), logger: LogProtocol = Log(category: .appStore)) {
        self.storeHelper = storeHelper
        log = logger
    }

    /// Indicates whether the user has full access.
    /// Returns true if the user has purchased the subscription product.
    var hasFullAccess: Bool {
        let subscriptionIds = AppProduct.subscriptions.map(\.id)
        return storeHelper.purchasedProducts.contains { subscriptionIds.contains($0) }
    }

    /// Synchronizes store data with the App Store.
    func syncStoreData() async throws {
        log.debug("Sync Store data")

        // Start StoreHelper if not already started
        if !storeHelper.hasStarted {
            await storeHelper.startAsync()
        }

        // Refresh products from App Store
        storeHelper.refreshProductsFromAppStore()

        log.debug("Products count: \(storeHelper.products?.count ?? 0)")
        log.debug("Purchased products: \(storeHelper.purchasedProducts)")
    }

    /// Initiates the purchase of a specified product.
    /// - Parameter product: The product to be purchased.
    /// - Returns: The result of the purchase attempt.
    func purchase(_ product: AppProduct) async throws -> PurchaseResult {
        // Ensure store is started
        if !storeHelper.hasStarted {
            await storeHelper.startAsync()
        }

        guard let storeProduct = storeHelper.product(from: product.id) else {
            log.error("Product not found: \(product.id)")
            throw AppStoreServiceError.missedProduct
        }

        log.debug("Purchasing product: \(product.id)")

        let (_, purchaseState) = try await storeHelper.purchase(storeProduct)

        log.debug("Purchase state: \(purchaseState)")

        switch purchaseState {
        case .purchased:
            return .success(product)
        case .cancelled:
            return .userCancelled
        case .pending:
            return .pending
        case .inProgress, .notStarted, .unknown, .notPurchased:
            return .userCancelled
        case .userCannotMakePayments:
            log.info("User cannot make payments")
            return .userCancelled
        case .failed, .failedVerification:
            log.error("Purchase failed or verification failed")
            return .userCancelled
        }
    }

    /// Retrieves information for a specified product.
    /// - Parameter product: The product to retrieve information for.
    /// - Returns: Information about the product.
    func info(for product: AppProduct) throws -> AppStoreProductInfo {
        guard let storeProduct = storeHelper.product(from: product.id) else {
            throw AppStoreServiceError.missedProduct
        }

        return AppStoreProductInfo(
            name: storeProduct.displayName,
            description: storeProduct.description,
            price: storeProduct.displayPrice
        )
    }
}

/// A preview implementation of `AppStoreProtocol` for testing purposes.
@MainActor
final class AppStorePreview: AppStoreProtocol {
    /// Initiates the purchase of a specified product.
    /// - Parameter product: The product to be purchased.
    /// - Returns: The result of the purchase attempt.
    func purchase(_: AppProduct) async throws -> PurchaseResult {
        .userCancelled
    }

    /// Synchronizes store data with the App Store.
    func syncStoreData() async throws {}

    /// Retrieves information for a specified product.
    /// - Parameter product: The product to retrieve information for.
    /// - Returns: Information about the product.
    func info(for _: AppProduct) throws -> AppStoreProductInfo {
        .init(name: "Preview", description: "test", price: "$9.99")
    }

    /// Indicates whether the user has full access.
    var hasFullAccess: Bool {
        false
    }
}
