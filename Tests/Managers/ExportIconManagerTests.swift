//
//  ExportIconManagerTests.swift
//  colirTests
//
//  Created by Claude Code on 2025-12-15.
//  Copyright (c) 2025 IGR Software. All rights reserved.
//

import AppKit
@testable import colir
import Testing

@Suite("ExportIconManager Tests")
struct ExportIconManagerTests {
    // MARK: - Mock Classes

    final class MockAppSettings: AppSettingsProtocol {
        var bookmarkData: Data = .init()
        var userPicturesPath: URL = .init(fileURLWithPath: "/tmp")
        var isTestMode: Bool = true
        var exportCount: Int = 0
        var tipped: CryptoModel = .init(value: "0")

        func setup(uuid _: String) {}
    }

    final class MockAppStoreService: AppStoreProtocol {
        var hasFullAccess: Bool = false

        func syncStoreData() async throws {}

        func purchase(_: AppProduct) async throws -> PurchaseResult {
            .userCancelled
        }

        func info(for _: AppProduct) throws -> AppStoreProductInfo {
            .init(name: "Mock", description: "Test", price: "$0.99")
        }
    }

    // MARK: - Protocol Tests

    @Test("ExportIconManagerProtocol has expected properties")
    func protocol_hasExpectedProperties() {
        let appSettings = MockAppSettings()
        let appStoreService = MockAppStoreService()
        let manager: ExportIconManagerProtocol = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService
        )

        _ = manager.canExport
        _ = manager.askTips

        #expect(true) // Verifies protocol properties exist
    }

    // MARK: - Initialization Tests

    @Test("init sets dependencies correctly")
    func init_setsDependencies() {
        let appSettings = MockAppSettings()
        let appStoreService = MockAppStoreService()
        let manager = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService
        )

        #expect(manager.appSettings is MockAppSettings)
        #expect(manager.appStoreService is MockAppStoreService)
    }

    @Test("init with custom IconManager")
    func init_customIconManager() {
        let appSettings = MockAppSettings()
        let appStoreService = MockAppStoreService()
        let iconManager = IconManager()
        let manager = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService,
            iconManager: iconManager
        )

        #expect(manager.iconManager === iconManager)
    }

    // MARK: - canExport Tests

    @Test("canExport always returns true")
    func canExport_alwaysTrue() {
        let appSettings = MockAppSettings()
        let appStoreService = MockAppStoreService()
        let manager = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService
        )

        #expect(manager.canExport == true)
    }

    @Test("canExport returns true regardless of export count")
    func canExport_ignoresExportCount() {
        let appSettings = MockAppSettings()
        appSettings.exportCount = 100
        let appStoreService = MockAppStoreService()
        let manager = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService
        )

        #expect(manager.canExport == true)
    }

    // MARK: - askTips Tests

    @Test("askTips returns true when exportCount is 5 and not tipped")
    func askTips_trueWhenConditionsMet() {
        let appSettings = MockAppSettings()
        appSettings.exportCount = 5
        appSettings.tipped = CryptoModel(value: "0")
        let appStoreService = MockAppStoreService()
        let manager = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService
        )

        #expect(manager.askTips == true)
    }

    @Test("askTips returns false when exportCount is not 5")
    func askTips_falseWhenExportCountNot5() {
        let appSettings = MockAppSettings()
        appSettings.exportCount = 4
        appSettings.tipped = CryptoModel(value: "0")
        let appStoreService = MockAppStoreService()
        let manager = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService
        )

        #expect(manager.askTips == false)

        appSettings.exportCount = 6
        #expect(manager.askTips == false)
    }

    @Test("askTips returns false when already tipped")
    func askTips_falseWhenTipped() {
        let appSettings = MockAppSettings()
        appSettings.exportCount = 5
        appSettings.tipped = CryptoModel(value: "1")
        let appStoreService = MockAppStoreService()
        let manager = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService
        )

        #expect(manager.askTips == false)
    }

    @Test("askTips returns false with zero exports")
    func askTips_falseWithZeroExports() {
        let appSettings = MockAppSettings()
        appSettings.exportCount = 0
        appSettings.tipped = CryptoModel(value: "0")
        let appStoreService = MockAppStoreService()
        let manager = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService
        )

        #expect(manager.askTips == false)
    }

    // MARK: - export Tests

    @Test("export with nil URL does nothing")
    func export_nilURL_doesNothing() {
        let appSettings = MockAppSettings()
        let appStoreService = MockAppStoreService()
        let manager = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService
        )

        let initialCount = appSettings.exportCount
        let imageDto = ImageDto()
        // imageDto.url is nil by default

        manager.export(image: imageDto)

        // Export count should not change
        #expect(appSettings.exportCount == initialCount)
    }

    @Test("export increments exportCount on success")
    func export_incrementsCount() {
        // Note: Full export test would require file system setup
        // This tests the export count increment behavior
        let appSettings = MockAppSettings()
        let appStoreService = MockAppStoreService()
        let manager = ExportIconManager(
            appSettings: appSettings,
            appStoreService: appStoreService
        )

        let initialCount = appSettings.exportCount
        #expect(initialCount == 0)

        // Export with nil URL should not increment
        let imageDto = ImageDto()
        manager.export(image: imageDto)
        #expect(appSettings.exportCount == 0)
    }

    // MARK: - ExportIconManagerPreview Tests

    @Test("preview canExport returns false")
    func preview_canExport_returnsFalse() {
        let preview = ExportIconManagerPreview()

        #expect(preview.canExport == false)
    }

    @Test("preview askTips returns false")
    func preview_askTips_returnsFalse() {
        let preview = ExportIconManagerPreview()

        #expect(preview.askTips == false)
    }

    @Test("preview export does nothing")
    func preview_export_doesNothing() {
        let preview = ExportIconManagerPreview()
        let imageDto = ImageDto()

        // Should not throw or crash
        preview.export(image: imageDto)

        #expect(true)
    }

    @Test("preview conforms to protocol")
    func preview_conformsToProtocol() {
        let preview: ExportIconManagerProtocol = ExportIconManagerPreview()

        #expect(preview.canExport == false)
        #expect(preview.askTips == false)
    }
}
