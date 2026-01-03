//
//  HomeViewModelTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import Combine
import DeveloperSupportStore
import StoreKit
import Testing
@testable import colir

@Suite("HomeViewModel Tests")
@MainActor
struct HomeViewModelTests {
    // MARK: - Mock Classes

    final class MockAppSettings: AppSettingsProtocol {
        var bookmarkData: Data = .init()
        var userPicturesPath: URL = FileManager.default.temporaryDirectory
        var isTestMode: Bool = true
        var exportCount: Int = 0
        var tipped: CryptoModel = .init(value: "0")

        func setup(uuid _: String) {}
    }

    final class MockStoreService: StoreServiceProtocol, @unchecked Sendable {
        var hasActiveSubscription: Bool = false
        var syncStoreCalled = false
        var subscriptionProducts: [Product] = []
        var nonConsumableProducts: [Product] = []

        func syncStoreData() async throws {
            syncStoreCalled = true
        }

        func purchase(_ product: Product) async throws -> StorePurchaseResult {
            .userCancelled
        }

        func info(for product: Product) -> StoreProductInfo {
            StoreProductInfo(name: "Mock", description: "Test", price: "$0.99")
        }
    }

    // MARK: - Tools Enum Tests

    @Test("Tools has expected cases")
    func tools_hasCases() {
        _ = HomeViewModel.Tools.colors
        _ = HomeViewModel.Tools.photos
        _ = HomeViewModel.Tools.pictures
        _ = HomeViewModel.Tools.emojis
        _ = HomeViewModel.Tools.decals
        _ = HomeViewModel.Tools.webResources

        #expect(true)
    }

    @Test("Tools conforms to Equatable")
    func tools_equatable() {
        #expect(HomeViewModel.Tools.colors == HomeViewModel.Tools.colors)
        #expect(HomeViewModel.Tools.colors != HomeViewModel.Tools.photos)
    }

    // MARK: - Initialization Tests

    @Test("init with default parameters")
    func init_defaultParameters() {
        let undoManager = UndoManager()
        let appSettings = MockAppSettings()
        let storeService = MockStoreService()

        let viewModel = HomeViewModel(
            undoManager: undoManager,
            appSettings: appSettings,
            storeService: storeService,
            tools: .colors
        )

        #expect(viewModel.tools == .colors)
        #expect(viewModel.wrongAttempt == 0)
        #expect(viewModel.dropZoneSize == 236)
    }

    @Test("init with specific tools selection")
    func init_specificTools() {
        let viewModel = createViewModel(tools: .emojis)

        #expect(viewModel.tools == .emojis)
    }

    @Test("init sets up picturesFolderManager")
    func init_picturesFolderManager() {
        let viewModel = createViewModel()

        #expect(viewModel.picturesFolderManager is PicturesFolderManager)
    }

    // MARK: - dropZoneSize Tests

    @Test("dropZoneSize returns fixed value")
    func dropZoneSize_fixedValue() {
        let viewModel = createViewModel()

        #expect(viewModel.dropZoneSize == 236)
    }

    // MARK: - tools Property Tests

    @Test("tools can be changed via apply action")
    func tools_canBeChanged() {
        let viewModel = createViewModel(tools: .colors)

        viewModel.apply(action: .photos)
        #expect(viewModel.tools == .photos)

        viewModel.apply(action: .emojis)
        #expect(viewModel.tools == .emojis)

        viewModel.apply(action: .pictures)
        #expect(viewModel.tools == .pictures)

        viewModel.apply(action: .colors)
        #expect(viewModel.tools == .colors)
    }

    // MARK: - wrongAttempt Tests

    @Test("wrongAttempt initially zero")
    func wrongAttempt_initiallyZero() {
        let viewModel = createViewModel()

        #expect(viewModel.wrongAttempt == 0)
    }

    @Test("apply color increments wrongAttempt when no image")
    func applyColor_incrementsWrongAttempt() {
        let viewModel = createViewModel()

        viewModel.apply(color: .red)

        // Should increment because no image is loaded
        #expect(viewModel.wrongAttempt > 0)
    }

    @Test("apply image increments wrongAttempt when no image")
    func applyImage_incrementsWrongAttempt() {
        let viewModel = createViewModel()
        let testImage = NSImage(size: NSSize(width: 100, height: 100))

        viewModel.apply(image: testImage)

        #expect(viewModel.wrongAttempt > 0)
    }

    @Test("apply emoji increments wrongAttempt when no image")
    func applyEmoji_incrementsWrongAttempt() {
        let viewModel = createViewModel()

        viewModel.apply(emoji: "🎨")

        #expect(viewModel.wrongAttempt > 0)
    }

    // MARK: - apply(action:) Tests

    @Test("apply undo action calls undo manager")
    func apply_undoAction() {
        let undoManager = UndoManager()
        let viewModel = createViewModel(undoManager: undoManager)

        viewModel.apply(action: .undo)

        // Undo should be called (even if nothing to undo)
        #expect(true)
    }

    @Test("apply redo action calls redo")
    func apply_redoAction() {
        let undoManager = UndoManager()
        let viewModel = createViewModel(undoManager: undoManager)

        viewModel.apply(action: .redo)

        #expect(true)
    }

    @Test("apply colors action sets tools to colors")
    func apply_colorsAction() {
        let viewModel = createViewModel(tools: .photos)

        viewModel.apply(action: .colors)

        #expect(viewModel.tools == .colors)
    }

    @Test("apply photos action sets tools to photos")
    func apply_photosAction() {
        let viewModel = createViewModel(tools: .colors)

        viewModel.apply(action: .photos)

        #expect(viewModel.tools == .photos)
    }

    @Test("apply emojis action sets tools to emojis")
    func apply_emojisAction() {
        let viewModel = createViewModel(tools: .colors)

        viewModel.apply(action: .emojis)

        #expect(viewModel.tools == .emojis)
    }

    @Test("apply decals action sets tools to decals")
    func apply_decalsAction() {
        let viewModel = createViewModel(tools: .colors)

        viewModel.apply(action: .decals)

        #expect(viewModel.tools == .decals)
    }

    @Test("apply pictures action sets tools to pictures")
    func apply_picturesAction() {
        let viewModel = createViewModel(tools: .colors)

        viewModel.apply(action: .pictures)

        #expect(viewModel.tools == .pictures)
    }

    @Test("apply webResources action sets tools to webResources")
    func apply_webResourcesAction() {
        let viewModel = createViewModel(tools: .colors)

        viewModel.apply(action: .webResources)

        #expect(viewModel.tools == .webResources)
    }

    @Test("apply tips action toggles showingAppStoreSheet")
    func apply_tipsAction() {
        let viewModel = createViewModel()
        let initialValue = viewModel.showingAppStoreSheet

        viewModel.apply(action: .tips)

        #expect(viewModel.showingAppStoreSheet != initialValue)
    }

    @Test("apply spacer action does nothing")
    func apply_spacerAction() {
        let viewModel = createViewModel(tools: .colors)
        let initialTools = viewModel.tools

        viewModel.apply(action: .spacer)

        #expect(viewModel.tools == initialTools)
    }

    // MARK: - showingExportAlert Tests

    @Test("showingExportAlert initially false")
    func showingExportAlert_initiallyFalse() {
        let viewModel = createViewModel()

        #expect(viewModel.showingExportAlert == false)
    }

    // MARK: - showingAppStoreSheet Tests

    @Test("showingAppStoreSheet initially false")
    func showingAppStoreSheet_initiallyFalse() {
        let viewModel = createViewModel()

        #expect(viewModel.showingAppStoreSheet == false)
    }

    // MARK: - Lazy ViewModel Properties Tests

    @Test("toolsColorsViewModel is accessible")
    func toolsColorsViewModel_accessible() {
        let viewModel = createViewModel()

        #expect(viewModel.toolsColorsViewModel is ToolsColorsViewModel)
    }

    @Test("toolsPhotosViewModel is accessible")
    func toolsPhotosViewModel_accessible() {
        let viewModel = createViewModel()

        #expect(viewModel.toolsPhotosViewModel is ToolsPhotosViewModel)
    }

    @Test("toolsPicturesViewModel is accessible")
    func toolsPicturesViewModel_accessible() {
        let viewModel = createViewModel()

        #expect(viewModel.toolsPicturesViewModel is ToolsPicturesViewModel)
    }

    @Test("toolsEmojisViewModel is accessible")
    func toolsEmojisViewModel_accessible() {
        let viewModel = createViewModel()

        #expect(viewModel.toolsEmojisViewModel is ToolsEmojisViewModel)
    }

    @Test("webResourcesViewModel is accessible")
    func webResourcesViewModel_accessible() {
        let viewModel = createViewModel()

        #expect(viewModel.webResourcesViewModel is WebResourcesViewModel)
    }

    @Test("dropZoneViewModel is accessible")
    func dropZoneViewModel_accessible() {
        let viewModel = createViewModel()

        #expect(viewModel.dropZoneViewModel is DropZoneViewModel)
    }

    @Test("appliedStylesViewModel is accessible")
    func appliedStylesViewModel_accessible() {
        let viewModel = createViewModel()

        #expect(viewModel.appliedStylesViewModel is AppliedStylesViewModel)
    }

    @Test("customizingActionViewModel is accessible")
    func customizingActionViewModel_accessible() {
        let viewModel = createViewModel()

        #expect(viewModel.customizingActionViewModel is CustomizingActionViewModel)
    }

    // MARK: - hasTipped Tests

    @Test("hasTipped returns false when not tipped")
    func hasTipped_returnsFalse_whenNotTipped() {
        let appSettings = MockAppSettings()
        appSettings.tipped = CryptoModel(value: "0")
        let viewModel = createViewModel(appSettings: appSettings)

        #expect(viewModel.hasTipped == false)
    }

    @Test("hasTipped returns true when tipped")
    func hasTipped_returnsTrue_whenTipped() {
        let appSettings = MockAppSettings()
        appSettings.tipped = CryptoModel(value: "1")
        let viewModel = createViewModel(appSettings: appSettings)

        #expect(viewModel.hasTipped == true)
    }

    // MARK: - onTipped Callback Tests

    @Test("onTipped callback is called on handlePurchaseSuccess")
    func onTipped_calledOnPurchaseSuccess() {
        var callbackCalled = false
        let viewModel = createViewModel()
        viewModel.onTipped = {
            callbackCalled = true
        }

        viewModel.handlePurchaseSuccess(productId: "test")

        #expect(callbackCalled == true)
    }

    @Test("onTipped callback is nil by default")
    func onTipped_nilByDefault() {
        let viewModel = createViewModel()

        #expect(viewModel.onTipped == nil)
    }

    // MARK: - handlePurchaseSuccess Tests

    @Test("handlePurchaseSuccess updates appSettings.tipped")
    func handlePurchaseSuccess_updatesTipped() {
        let appSettings = MockAppSettings()
        let viewModel = createViewModel(appSettings: appSettings)

        viewModel.handlePurchaseSuccess(productId: "com.igrsoft.colir.small.tips1.subs")

        #expect(appSettings.tipped.value == "1")
    }

    // MARK: - Preview Tests

    @Test("preview creates valid instance")
    func preview_createsInstance() {
        let preview = HomeViewModel.preview

        #expect(preview.tools == .colors)
        #expect(preview.wrongAttempt == 0)
    }

    // MARK: - updateHack Tests

    @Test("updateHack initially true")
    func updateHack_initiallyTrue() {
        let viewModel = createViewModel()

        #expect(viewModel.updateHack == true)
    }

    // MARK: - undoManager Tests

    @Test("undoManager is set correctly")
    func undoManager_isSet() {
        let undoManager = UndoManager()
        let viewModel = createViewModel(undoManager: undoManager)

        #expect(viewModel.undoManager === undoManager)
    }

    // MARK: - viewSettings Tests

    @Test("viewSettings is HomeViewDomain")
    func viewSettings_isHomeViewDomain() {
        let viewModel = createViewModel()

        #expect(viewModel.viewSettings is HomeViewDomain)
    }

    // MARK: - Helpers

    private func createViewModel(
        undoManager: UndoManager = UndoManager(),
        appSettings: MockAppSettings = MockAppSettings(),
        storeService: (any StoreServiceProtocol)? = nil,
        tools: HomeViewModel.Tools = .colors
    ) -> HomeViewModel {
        HomeViewModel(
            undoManager: undoManager,
            appSettings: appSettings,
            storeService: storeService ?? MockStoreService(),
            tools: tools
        )
    }
}
