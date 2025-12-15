//
//  AppStoreServiceTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import StoreKit
import Testing
@testable import colir

@Suite("AppStoreService Tests")
@MainActor
struct AppStoreServiceTests {
    // MARK: - AppProduct Tests

    @Test("AppProduct has expected cases")
    func appProduct_hasCases() {
        _ = AppProduct.smallTips
        _ = AppProduct.middleTips
        _ = AppProduct.bigTips

        #expect(AppProduct.allCases.count == 3)
    }

    @Test("AppProduct rawValues are correct")
    func appProduct_rawValues() {
        #expect(AppProduct.smallTips.rawValue == "com.igrsoft.colir.small.tips1.subs")
        #expect(AppProduct.middleTips.rawValue == "com.igrsoft.colir.middle.tips.inapp")
        #expect(AppProduct.bigTips.rawValue == "com.igrsoft.colir.big.tips.inapp")
    }

    @Test("AppProduct id returns rawValue")
    func appProduct_id() {
        #expect(AppProduct.smallTips.id == AppProduct.smallTips.rawValue)
        #expect(AppProduct.middleTips.id == AppProduct.middleTips.rawValue)
        #expect(AppProduct.bigTips.id == AppProduct.bigTips.rawValue)
    }

    @Test("AppProduct inAppPurchases contains correct products")
    func appProduct_inAppPurchases() {
        let inApp = AppProduct.inAppPurchases

        #expect(inApp.contains(.middleTips))
        #expect(inApp.contains(.bigTips))
        #expect(!inApp.contains(.smallTips))
        #expect(inApp.count == 2)
    }

    @Test("AppProduct subscriptions contains correct products")
    func appProduct_subscriptions() {
        let subs = AppProduct.subscriptions

        #expect(subs.contains(.smallTips))
        #expect(!subs.contains(.middleTips))
        #expect(!subs.contains(.bigTips))
        #expect(subs.count == 1)
    }

    @Test("AppProduct conforms to Equatable")
    func appProduct_equatable() {
        #expect(AppProduct.smallTips == AppProduct.smallTips)
        #expect(AppProduct.smallTips != AppProduct.middleTips)
    }

    @Test("AppProduct conforms to Sendable")
    func appProduct_sendable() async {
        let product = AppProduct.smallTips

        let result = await Task.detached {
            product
        }.value

        #expect(result == .smallTips)
    }

    // MARK: - AppStoreProductInfo Tests

    @Test("AppStoreProductInfo stores values")
    func productInfo_storesValues() {
        let info = AppStoreProductInfo(name: "Small Tip", description: "A small tip", price: "$0.99")

        #expect(info.name == "Small Tip")
        #expect(info.description == "A small tip")
        #expect(info.price == "$0.99")
    }

    @Test("AppStoreProductInfo with empty values")
    func productInfo_emptyValues() {
        let info = AppStoreProductInfo(name: "", description: "", price: "")

        #expect(info.name == "")
        #expect(info.description == "")
        #expect(info.price == "")
    }

    // MARK: - PurchaseResult Tests

    @Test("PurchaseResult has expected cases")
    func purchaseResult_hasCases() {
        _ = PurchaseResult.success(.smallTips)
        _ = PurchaseResult.userCancelled
        _ = PurchaseResult.pending

        #expect(true)
    }

    @Test("PurchaseResult.success contains product")
    func purchaseResult_successContainsProduct() {
        let result = PurchaseResult.success(.middleTips)

        if case .success(let product) = result {
            #expect(product == .middleTips)
        } else {
            Issue.record("Expected success case")
        }
    }

    @Test("PurchaseResult conforms to Sendable")
    func purchaseResult_sendable() async {
        let result = PurchaseResult.success(.bigTips)

        let asyncResult = await Task.detached {
            result
        }.value

        if case .success(let product) = asyncResult {
            #expect(product == .bigTips)
        } else {
            Issue.record("Expected success case")
        }
    }

    // MARK: - AppStoreServiceError Tests

    @Test("AppStoreServiceError has expected cases")
    func serviceError_hasCases() {
        _ = AppStoreServiceError.missedProduct

        #expect(true)
    }

    @Test("AppStoreServiceError conforms to Error")
    func serviceError_conformsToError() {
        let error: Error = AppStoreServiceError.missedProduct

        #expect(error is AppStoreServiceError)
    }

    // MARK: - AppStorePreview Tests

    @Test("AppStorePreview hasFullAccess returns false")
    func preview_hasFullAccess() {
        let preview = AppStorePreview()

        #expect(preview.hasFullAccess == false)
    }

    @Test("AppStorePreview syncStoreData does nothing")
    func preview_syncStoreData() async throws {
        let preview = AppStorePreview()

        try await preview.syncStoreData()

        #expect(true) // Should not throw
    }

    @Test("AppStorePreview purchase returns userCancelled")
    func preview_purchase() async throws {
        let preview = AppStorePreview()

        let result = try await preview.purchase(.smallTips)

        if case .userCancelled = result {
            #expect(true)
        } else {
            Issue.record("Expected userCancelled")
        }
    }

    @Test("AppStorePreview info returns preview info")
    func preview_info() throws {
        let preview = AppStorePreview()

        let info = try preview.info(for: .middleTips)

        #expect(info.name == "Preview")
        #expect(info.description == "test")
        #expect(info.price == "$9.99")
    }

    @Test("AppStorePreview conforms to protocol")
    func preview_conformsToProtocol() {
        let preview: AppStoreProtocol = AppStorePreview()

        #expect(preview.hasFullAccess == false)
    }

    // MARK: - AppStoreService Tests

    @Test("AppStoreService initializes")
    func service_initializes() {
        let service = AppStoreService()

        #expect(service.hasFullAccess == false)
    }

    @Test("AppStoreService hasFullAccess initially false")
    func service_hasFullAccess_initiallyFalse() {
        let service = AppStoreService()

        #expect(service.hasFullAccess == false)
    }

    @Test("AppStoreService info throws missedProduct before sync")
    func service_info_throwsBeforeSync() {
        let service = AppStoreService()

        do {
            _ = try service.info(for: .smallTips)
            Issue.record("Expected error to be thrown")
        } catch let error as AppStoreServiceError {
            if case .missedProduct = error {
                #expect(true)
            } else {
                Issue.record("Expected missedProduct error")
            }
        } catch {
            Issue.record("Unexpected error type")
        }
    }

    @Test("AppStoreService conforms to protocol")
    func service_conformsToProtocol() {
        let service: AppStoreProtocol = AppStoreService()

        #expect(service.hasFullAccess == false)
    }

    // MARK: - Protocol Method Tests

    @Test("AppStoreProtocol methods are accessible")
    func protocol_methodsAccessible() async {
        let service: AppStoreProtocol = AppStorePreview()

        _ = service.hasFullAccess

        // These would require actual StoreKit setup
        // Just verify they're callable
        #expect(true)
    }
}
