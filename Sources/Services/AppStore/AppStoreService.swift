//
//  AppStoreService.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 11.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
import StoreKitPlus
import StoreKit

public enum AppProduct: String, CaseIterable, Equatable, ProductRepresentable {

    case add1Folder = "com.igrsoft.colir.1.folders.inapp"
    case add5Folder = "com.igrsoft.colir.5.folders.inapp"
    case add15Folder = "com.igrsoft.colir.15.folders.inapp"
    
    case fullAccessLifetime = "com.igrsoft.full.access.inapp"
    
    case fullAccess1Month = "com.igrsoft.colir.full.access.month.subs"
    case fullAccess3Month = "com.igrsoft.colir.full.access.3month.subs"
    case fullAccessYear = "com.igrsoft.colir.full.access.year.subs"

    public var id: String { rawValue }
    
    static var inAppPurchases: [AppProduct] {
        [.fullAccessLifetime, .add1Folder, .add5Folder, .add15Folder]
    }
    
    static var subscriptions: [AppProduct] {
        [.fullAccessLifetime, .fullAccess1Month, .fullAccess3Month, .fullAccessYear]
    }
}

public struct AppStoreProductInfo {
    let name: String
    
    let description: String
    
    let price: String
}

public protocol AppStoreProtocol {
    
    func syncStoreData() async throws
    
    func restorePurchases() async throws
    
    func getProducts() async throws -> [Product]
    
    func purchase(_ product: AppProduct) async throws -> Product.PurchaseResult
    
    func purchased() -> Set<AppProduct>?
    
    func info(for product: AppProduct) throws -> AppStoreProductInfo
    
    var hasFullAccess: Bool { get }
}

enum AppStoreServiceError: Error {
    case missedProduct
}

final class AppStoreService: AppStoreProtocol {
    
    private let context = StoreContext()
    
    private var storeService: StoreService {
        return StandardStoreService(products: AppProduct.allCases, context: context)
    }
    
    private var products: [AppProduct: Product]?
    
    private var purchasedProducts: Set<AppProduct>?
    
    private var log: LogProtocol
    
    init(logger: LogProtocol = Log(category: .appStore)) {
        self.log = logger
    }
    
    var hasFullAccess: Bool {
        guard let purchasedProducts, purchasedProducts.isEmpty == false else { return false }
        
        return Set(AppProduct.subscriptions).isSuperset(of: purchasedProducts)
    }
    
    func syncStoreData() async throws {
        log.debug("sync Store Data")
        
        try await storeService.syncStoreData()
    }
    
    func getProducts() async throws -> [Product] {
        let products = try await storeService.getProducts()
        
        self.products = products.reduce(into: [AppProduct: Product](), { partialResult, product in
            if let id = AppProduct(rawValue: product.id) {
                partialResult[id] = product
            }
        })
        
        log.debug("got products: \(products)")
        
        return products
    }
    
    func restorePurchases() async throws {
        try await storeService.restorePurchases()
        log.debug("restored Purchases")
    }
    
    func purchase(_ product: AppProduct) async throws -> Product.PurchaseResult {
        guard let appStoreProduct = products?[product] else {
            throw AppStoreServiceError.missedProduct
        }
        
        log.debug("purchase product: \(appStoreProduct)")
        
        return try await storeService.purchase(appStoreProduct)
    }
    
    func info(for product: AppProduct) throws -> AppStoreProductInfo {
        guard let appStoreProduct = products?[product] else {
            throw AppStoreServiceError.missedProduct
        }
        
        return .init(name: appStoreProduct.displayName, description: appStoreProduct.description, price: appStoreProduct.displayPrice)
    }
    
    func purchased() -> Set<AppProduct>? {
        let products = AppProduct.allCases
        let purchased = products.purchased(in: context)
        
        let purchasedProducts = purchased.reduce(into: Set<AppProduct>(), { partialResult, product in
            if let id = AppProduct(rawValue: product.id) {
                partialResult.insert(id)
            }
        })
        
        self.purchasedProducts = purchasedProducts.isEmpty ? nil : purchasedProducts
        
        log.debug("got purchased products: \(purchasedProducts)")
        
        return self.purchasedProducts
    }
}

final class AppStorePreview: AppStoreProtocol {
    func purchase(_ product: AppProduct) async throws -> Product.PurchaseResult {
        return .userCancelled
    }
    
    func syncStoreData() async throws {}
    
    func restorePurchases() async throws {}
    
    func getProducts() async throws -> [Product] {
        []
    }
    
    func purchased() -> Set<AppProduct>? {
        []
    }
    
    func info(for product: AppProduct) throws -> AppStoreProductInfo {
        .init(name: "Preview", description: "test", price: "$9.99")
    }
    
    var hasFullAccess: Bool {
        false
    }
}
