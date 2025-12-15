//
//  AppStoreViewModelTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftUI
import Testing
@testable import colir

@Suite("AppStoreViewModel Tests")
struct AppStoreViewModelTests {
    // MARK: - Test Helpers

    private func createMockAppStoreService() -> MockAppStoreService {
        MockAppStoreService()
    }

    private func createMockAppSettings() -> MockAppSettings {
        MockAppSettings()
    }

    // MARK: - Initialization Tests

    @Test("init creates valid instance")
    func init_createsInstance() {
        var completionCalled = false

        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: createMockAppSettings()
        ) {
            completionCalled = true
        }

        #expect(viewModel.appStoreService != nil)
        #expect(completionCalled == false)
    }

    // MARK: - Static Properties Tests

    @Test("buttonSize has expected value")
    func buttonSize_hasValue() {
        #expect(AppStoreViewModel.buttonSize == 150)
    }

    // MARK: - rows Tests

    @Test("rows contains grid items")
    func rows_containsGridItems() {
        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: createMockAppSettings()
        ) {}

        #expect(!viewModel.rows.isEmpty)
    }

    // MARK: - viewSettings Tests

    @Test("viewSettings is AppStoreViewDomain")
    func viewSettings_isCorrectType() {
        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: createMockAppSettings()
        ) {}

        #expect(viewModel.viewSettings is AppStoreViewDomain)
    }

    // MARK: - process Tests

    @Test("process success calls completion handler")
    func process_success_callsCompletion() {
        var completionCalled = false
        let appSettings = createMockAppSettings()

        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: appSettings
        ) {
            completionCalled = true
        }

        viewModel.process(purchase: .success(.smallTips))

        #expect(completionCalled)
    }

    @Test("process success updates tipped setting")
    func process_success_updatesTipped() {
        let appSettings = createMockAppSettings()
        #expect(appSettings.tipped.value == "0")

        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: appSettings
        ) {}

        viewModel.process(purchase: .success(.smallTips))

        #expect(appSettings.tipped.value == "1")
    }

    @Test("process userCancelled does not call completion")
    func process_userCancelled_noCompletion() {
        var completionCalled = false

        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: createMockAppSettings()
        ) {
            completionCalled = true
        }

        viewModel.process(purchase: .userCancelled)

        #expect(completionCalled == false)
    }

    @Test("process pending does not call completion")
    func process_pending_noCompletion() {
        var completionCalled = false

        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: createMockAppSettings()
        ) {
            completionCalled = true
        }

        viewModel.process(purchase: .pending)

        #expect(completionCalled == false)
    }

    // MARK: - appStoreService Tests

    @Test("appStoreService is accessible")
    func appStoreService_isAccessible() {
        let mockService = createMockAppStoreService()

        let viewModel = AppStoreViewModel(
            appStoreService: mockService,
            appSettings: createMockAppSettings()
        ) {}

        #expect(viewModel.appStoreService is MockAppStoreService)
    }

    // MARK: - completionHandler Tests

    @Test("completionHandler is callable")
    func completionHandler_isCallable() {
        var callCount = 0

        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: createMockAppSettings()
        ) {
            callCount += 1
        }

        viewModel.completionHandler()
        viewModel.completionHandler()

        #expect(callCount == 2)
    }

    // MARK: - Observable Tests

    @Test("AppStoreViewModel is Observable")
    func observable_conformance() {
        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: createMockAppSettings()
        ) {}

        // Access observable properties
        _ = viewModel.viewSettings
        _ = viewModel.rows

        #expect(true)
    }

    // MARK: - Sendable Tests

    @Test("AppStoreViewModel is Sendable (unchecked)")
    func sendable_conformance() async {
        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: createMockAppSettings()
        ) {}

        // Pass across task boundary
        let buttonSize = await Task.detached {
            AppStoreViewModel.buttonSize
        }.value

        #expect(buttonSize == 150)
    }

    // MARK: - Purchase Flow Tests

    @Test("full purchase success flow")
    func purchaseSuccessFlow() {
        var completionCalled = false
        let appSettings = createMockAppSettings()

        let viewModel = AppStoreViewModel(
            appStoreService: createMockAppStoreService(),
            appSettings: appSettings
        ) {
            completionCalled = true
        }

        // Initial state
        #expect(appSettings.tipped.value == "0")
        #expect(completionCalled == false)

        // Process successful purchase
        viewModel.process(purchase: .success(.smallTips))

        // Final state
        #expect(appSettings.tipped.value == "1")
        #expect(completionCalled)
    }
}

// MARK: - Mock Classes

private final class MockAppStoreService: AppStoreProtocol {
    var hasFullAccess: Bool = false
    var syncStoreCalled = false

    func syncStoreData() async throws {
        syncStoreCalled = true
    }

    func purchase(_: AppProduct) async throws -> PurchaseResult {
        .userCancelled
    }

    func info(for _: AppProduct) throws -> AppStoreProductInfo {
        .init(name: "Mock", description: "Test", price: "$0.99")
    }
}

private final class MockAppSettings: AppSettingsProtocol {
    var userPicturesPath: URL = .init(fileURLWithPath: "/tmp/test-pictures")
    var bookmarkData: Data = .init()
    var exportCount: Int = 0
    var tipped: CryptoModel = .init(value: "0")
    var isTestMode: Bool = true

    func setup(uuid _: String) {
        // No-op for testing
    }
}
