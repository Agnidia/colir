//
//  HomeViewModel.swift
//
//  Created on 15.09.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import Combine
import DeveloperSupportStore
import SwiftCommons
import SwiftUI

/// The view model for the `HomeView`, handling data and state management related to
/// image customization, tool selection, and app settings. It integrates with various services
/// to provide functionality such as applying colors, images, emojis, and managing undo actions.
@MainActor
final class HomeViewModel: ObservableObject, DomainViewConstantProtocol {
    /// View settings for configuring appearance and behavior.
    let viewSettings: HomeViewDomain = .init()

    typealias DomainViewConstantType = HomeViewDomain

    /// Enumeration representing different tool types available in the view.
    enum Tools: Equatable {
        case colors
        case photos
        case pictures
        case emojis
        case decals
        case webResources
    }

    /// Undo manager for handling undo and redo actions.
    private(set) var undoManager: UndoManager

    /// Manager for handling picture folders.
    let picturesFolderManager: PicturesFolderManagerProtocol

    /// App settings configuration.
    private var appSettings: AppSettingsProtocol

    /// Manager for exporting icons.
    private var exportIconManager: ExportIconManagerProtocol

    /// Service for store interactions.
    let storeService: any StoreServiceProtocol

    /// Whether the user has made a tip purchase.
    var hasTipped: Bool {
        appSettings.tipped.value == "1"
    }

    /// Callback to notify when user has tipped.
    var onTipped: (() -> Void)?

    /// Parser for `.rsrc` files.
    private lazy var rsrcFileParser = RSRCFileParser()

    /// Logger for recording logs and errors.
    private let log: LogProtocol

    /// URLs for folders used in the application.
    private var foldersUrls: [URL]

    /// Fixed width for the view.
    var dropZoneSize: CGFloat {
        236
    }

    /// The currently selected tool.
    @Published private(set) var tools: Tools

    /// Counter for wrong attempts, used for feedback in the UI.
    @Published var wrongAttempt: Int = .zero

    /// Flag used to force a UI update.
    @Published var updateHack = true

    /// Task for managing ongoing customization operations.
    private var customizationTask: Task<Void, Never>?

    /// Collection of cancellable publishers for Combine.
    private var cancellables = Set<AnyCancellable>()

    /// Initializes the `HomeViewModel` with default or provided dependencies.
    /// - Parameters:
    ///   - undoManager: An `UndoManager` for handling undo/redo actions.
    ///   - appSettings: An optional `AppSettingsProtocol` for configuration.
    ///   - storeService: An optional `StoreServiceProtocol` for store interactions.
    ///   - logger: An optional `LogProtocol` for logging.
    ///   - foldersUrls: URLs for folders to be used in the application.
    ///   - folderImage: Optional image for the folder.
    ///   - tools: The initial tool to be selected.
    init(undoManager: UndoManager,
         appSettings: AppSettingsProtocol = AppSettings(),
         storeService: any StoreServiceProtocol,
         logger: LogProtocol = Log(category: .home),
         foldersUrls: [URL] = [],
         folderImage _: NSImage? = nil,
         tools: Tools = .colors)
    {
        self.undoManager = undoManager
        self.appSettings = appSettings

        // Initialize store service with default if not provided
        self.storeService = storeService

        picturesFolderManager = PicturesFolderManager(picturesDirectory: appSettings.userPicturesPath)
        exportIconManager = ExportIconManager(appSettings: appSettings)
        log = logger

        self.foldersUrls = foldersUrls

        self.tools = tools

        setupFolders(from: self.foldersUrls)

        addPublishers()

        #if DEBUG
            Task {
                try? await Task.sleep(for: .seconds(2))
                dropZoneViewModel.fileClosure([picturesFolderManager.picturesDirectory])
            }
        #endif
    }

    deinit {
        // Clean up resources if needed
    }

    /// Applies a color to the current image, handling errors and updating the view.
    /// - Parameter color: The color to apply.
    func apply(color: NSColor?) {
        guard dropZoneViewModel.image.state != .none else {
            withAnimation(.default) {
                wrongAttempt += 1
            }
            return
        }

        customizationTask?.cancel()

        customizationTask = Task {
            await dropZoneViewModel.image.customisations.apply(color: color)

            do {
                try await dropZoneViewModel.image.update(customisations: dropZoneViewModel.image.customisations)
            } catch {
                print("task canceled")
            }
        }
    }

    /// Applies an image to the current image, handling errors and updating the view.
    /// - Parameters:
    ///   - image: The image to apply.
    ///   - asset: Optional photo asset related to the image.
    ///   - item: Optional picture item related to the image.
    func apply(image: NSImage?, asset: PhotoAsset? = nil, item: PictureItem? = nil) {
        guard dropZoneViewModel.image.state != .none else {
            wrongAttempt += 1
            return
        }

        var updateImage = image

        if let realImage = updateImage {
            let picture = realImage.scaled(to: .init(width: 1024, height: 1024))
            updateImage = picture.cutImage(by: .folderCenterFrame)
        }

        customizationTask?.cancel()

        customizationTask = Task { [updateImage, dropZoneViewModel] in
            await dropZoneViewModel.image.customisations.apply(picture: updateImage, asset: asset, item: item)

            do {
                try await dropZoneViewModel.image.update(customisations: dropZoneViewModel.image.customisations)
            } catch {
                print("task canceled")
            }
        }
    }

    /// Applies an emoji to the current image, handling errors and updating the view.
    /// - Parameter emoji: The emoji to apply.
    func apply(emoji: Character?) {
        guard dropZoneViewModel.image.state != .none else {
            wrongAttempt += 1
            return
        }

        customizationTask?.cancel()

        customizationTask = Task { [dropZoneViewModel, emoji] in
            await dropZoneViewModel.image.customisations.apply(emoji: emoji)

            do {
                try await dropZoneViewModel.image.update(customisations: dropZoneViewModel.image.customisations)
            } catch {
                print("task canceled")
            }
        }
    }

    /// Handles actions from the toolbar, such as undo, redo, and tool selection.
    /// - Parameter action: The action to perform.
    @MainActor
    func apply(action: ToolbarView.ToolbarViewDomain.Action) {
        switch action {
        case .undo:
            skipSelectedColor = true
            undoManager.undo()
        case .redo:
            skipSelectedColor = true
            undoManager.redo()
        case .colors: tools = .colors
        case .photos: tools = .photos
        case .emojis: tools = .emojis
        case .decals: tools = .decals
        case .spacer: break
        case .pictures: tools = .pictures
        case .webResources: tools = .webResources
        case .tips: showingAppStoreSheet.toggle()
        }
    }

    // Flags for skipping and applying selections
    private var skipSelectedColor = false
    private var skipSelectedPhoto = false
    private var skipSelectedPicture = false
    private var skipSelectedEmoji = false

    private var isApplyingSelectedPhoto = false
    private var isApplyingSelectedPicture = false
    private var isApplyingSelectedEmoji = false

    /// Subscribes to view model publishers to handle updates for color, photo, picture, and emoji selections.
    private func addPublishers() {
        toolsColorsViewModel.selectedColorPublisher
            .throttle(for: .milliseconds(400), scheduler: RunLoop.main, latest: true)
            .sink(receiveValue: setup(color:))
            .store(in: &cancellables)

        toolsPhotosViewModel.selectedImagePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: setup(item:))
            .store(in: &cancellables)

        toolsPicturesViewModel.$selectedImage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: setup(picture:))
            .store(in: &cancellables)

        toolsEmojisViewModel.$selectedEmoji
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: setup(emoji:))
            .store(in: &cancellables)
    }

    private func setup(color: NSColor?) {
        guard skipSelectedColor == false else {
            skipSelectedColor = false
            return
        }

        apply(color: color)
    }

    private func setup(item: (NSImage?, PhotoAsset?)) {
        guard skipSelectedPhoto == false else {
            skipSelectedPhoto = false
            return
        }

        guard isApplyingSelectedPicture == false else {
            isApplyingSelectedPicture = false
            return
        }

        isApplyingSelectedPhoto = true
        toolsPicturesViewModel.selectedImage = nil
        apply(image: item.0, asset: item.1)
    }

    private func setup(picture: PictureItem?) {
        guard skipSelectedPicture == false else {
            skipSelectedPicture = false
            return
        }

        guard isApplyingSelectedPhoto == false else {
            isApplyingSelectedPhoto = false
            return
        }

        isApplyingSelectedPicture = true
        toolsPhotosViewModel.selectedAsset = nil
        apply(image: picture?.image, item: picture)
        isApplyingSelectedPicture = false
    }

    private func setup(emoji: Character?) {
        guard skipSelectedEmoji == false else {
            skipSelectedEmoji = false
            return
        }

        isApplyingSelectedEmoji = true
        apply(emoji: emoji)
        isApplyingSelectedEmoji = false
    }

    // Lazy instantiation of view models used in tools and customization.
    private(set) lazy var toolsColorsViewModel: ToolsColorsViewModel = .init()
    private(set) lazy var toolsPhotosViewModel: ToolsPhotosViewModel = .init()
    private(set) lazy var toolsPicturesViewModel: ToolsPicturesViewModel = .init(appSettings: appSettings, picturesFolderManager: picturesFolderManager)
    private(set) lazy var toolsEmojisViewModel: ToolsEmojisViewModel = .init()
    private(set) lazy var webResourcesViewModel: WebResourcesViewModel = .init()

    // Lazy instantiation of drop zone view model.
    private(set) lazy var dropZoneViewModel: DropZoneViewModel = .init(fileClosure: setupFolders(from:)) { state in
        Task { @MainActor [weak self] in
            self?.update(state: state)
        }
    }

    @MainActor
    private func update(state: ImageDto.ImageState) {
        log.debug("Set state to: \(state)")
        customizingActionViewModel.update(state: state)
        appliedStylesViewModel.update(state: state, imageCustomization: dropZoneViewModel.image.customisations)
        if state == .ready {
            let index = currentUndoItem + 1
            undoItems = Array(undoItems.prefix(index))
            undoItems.append(dropZoneViewModel.image.undoItems)
            add(index: index + 1, needUpdate: false)
        }
    }

    // Lazy instantiation of applied styles view model.
    private(set) lazy var appliedStylesViewModel: AppliedStylesViewModel = .init(toolsColorsViewModel: toolsColorsViewModel, toolsPhotosViewModel: toolsPhotosViewModel, toolsPicturesViewModel: toolsPicturesViewModel, toolsEmojisViewModel: toolsEmojisViewModel)

    // Lazy instantiation of customizing action view model.
    private(set) lazy var customizingActionViewModel: CustomizingActionViewModel = .init(actionClosure: exportIcon)

    @Published var showingExportAlert = false
    @Published var showingAppStoreSheet = false

    private func exportIcon() {
        let image = dropZoneViewModel.image

        exportIconManager.export(image: image)

        guard exportIconManager.askTips else { return }

        showingExportAlert.toggle()
    }

    /// Opens a folder in the drop zone view.
    @MainActor
    func openFolder() {
        dropZoneViewModel.openFolder()
    }

    /// Sets up folders based on the provided URLs, initializing the drop zone view model
    /// and updating the view with the folder's icon or image.
    /// - Parameter urls: The URLs of the folders to set up.
    func setupFolders(from urls: [URL]) {
        let folders = urls.filter(\.isFolder)

        guard folders.isEmpty == false, let url = folders.first else {
            return
        }

        dropZoneViewModel.image.prepareForUpdate()

        Task {
            var icon: NSImage?

            let rsrcFile = url.appendingPathComponent("Icon\r/..namedfork/rsrc")
            if FileManager.default.fileExists(atPath: rsrcFile.path(percentEncoded: false)) {
                var resource: RSRCResource?
                do {
                    resource = try rsrcFileParser.parse(url: rsrcFile).first
                } catch {
                    print(error.localizedDescription)
                }

                guard let resource, let image = resource.image else {
                    return
                }

                icon = image
            } else {
                icon = url.icon
            }

            guard let icon else {
                return
            }

            await dropZoneViewModel.image.updateOriginal(url: url, image: icon)

            undoItems.removeAll()
            undoItems.append(dropZoneViewModel.image.undoItems)
            currentUndoItem = .zero

            foldersUrls = [url]
        }
    }

    /// List of undo items for managing undo/redo actions.
    private var undoItems: [ImageUndoDto] = .init()
    private var currentUndoItem: Int = .zero

    /// Adds an undo item to the undo stack and updates the current index.
    /// - Parameter index: The index of the undo item to add.
    @MainActor
    private func add(index: Int, needUpdate: Bool) {
        currentUndoItem = index

        undoManager.registerUndo(withTarget: self) {
            $0.remove(index: index, needUpdate: true)
        }

        setupItemsForCurrentIndex(needUpdate: needUpdate)
    }

    /// Removes an undo item from the undo stack and updates the current index.
    /// - Parameter index: The index of the undo item to remove.
    @MainActor
    private func remove(index: Int, needUpdate: Bool) {
        currentUndoItem = index - 1

        undoManager.registerUndo(withTarget: self) {
            $0.add(index: index, needUpdate: true)
        }

        setupItemsForCurrentIndex(needUpdate: needUpdate)
    }

    /// Sets up the view state for the current undo item.
    private func setupItemsForCurrentIndex(needUpdate: Bool) {
        guard let image = undoItems[safe: currentUndoItem] else { return }

        dropZoneViewModel.update(from: image)

        if needUpdate {
            toolsColorsViewModel.selectedColor = image.customisations.selectedColor

            skipSelectedPhoto = true
            toolsPhotosViewModel.selectedPicture = image.customisations.selectedPicture
            toolsPhotosViewModel.selectedAsset = image.customisations.selectedAsset

            skipSelectedPicture = true
            toolsPicturesViewModel.selectedImage = image.customisations.selectedPictureItem
        }

        appliedStylesViewModel.update(state: .none, imageCustomization: dropZoneViewModel.image.customisations)

        updateHack.toggle()
    }

    /// Handles a successful purchase by updating app settings.
    /// - Parameter productId: The identifier of the purchased product.
    func handlePurchaseSuccess(productId _: String) {
        appSettings.tipped = CryptoModel(value: "1")
        onTipped?()
    }
}

extension HomeViewModel {
    @MainActor
    static var preview: HomeViewModel {
        HomeViewModel(undoManager: UndoManager(), storeService: StoreServicePreview())
    }
}
