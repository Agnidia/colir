//
//  HomeViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 24.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI
import SwiftCommons
import Combine

/// The view model for the `HomeView`, handling data and state management related to
/// image customization, tool selection, and app settings. It integrates with various services
/// to provide functionality such as applying colors, images, emojis, and managing undo actions.
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
    
    /// Service for app store interactions.
    private var appStoreService: AppStoreProtocol
    
    /// Parser for `.rsrc` files.
    private lazy var rsrcFileParser = RSRCFileParser()
    
    /// Logger for recording logs and errors.
    private let log: LogProtocol
    
    /// URLs for folders used in the application.
    private var foldersUrls: [URL]
    
    /// Fixed width for the view.
    var width: CGFloat {
        236
    }
    
    /// The currently selected tool.
    @Published private var tools: Tools
    
    /// Counter for wrong attempts, used for feedback in the UI.
    @Published var wrongAttempt: Int = .zero
    
    /// Flag used to force a UI update.
    @Published var updateHack = true
    
    /// Task for managing ongoing customization operations.
    private var customizationTask: Task<(), Never>?
    
    /// Collection of cancellable publishers for Combine.
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes the `HomeViewModel` with default or provided dependencies.
    /// - Parameters:
    ///   - undoManager: An optional `UndoManager` for handling undo/redo actions.
    ///   - appSettings: An optional `AppSettingsProtocol` for configuration.
    ///   - appStoreService: An optional `AppStoreProtocol` for app store interactions.
    ///   - logger: An optional `LogProtocol` for logging.
    ///   - foldersUrls: URLs for folders to be used in the application.
    ///   - folderImage: Optional image for the folder.
    ///   - tools: The initial tool to be selected.
    init(undoManager: UndoManager = .init(),
         appSettings: AppSettingsProtocol = AppSettings(),
         appStoreService: AppStoreProtocol = AppStoreService(),
         logger: LogProtocol = Log(category: .home),
         foldersUrls: [URL] = [],
         folderImage: NSImage? = nil,
         tools: Tools = .colors) {
        self.undoManager = undoManager
        self.appSettings = appSettings
        self.appStoreService = appStoreService
        self.picturesFolderManager = PicturesFolderManager(picturesDirectory: appSettings.userPicturesPath)
        self.exportIconManager = ExportIconManager(appSettings: appSettings, appStoreService: appStoreService)
        self.log = logger
        
        #if DEBUG
        self.foldersUrls = [picturesFolderManager.picturesDirectory]
        #else
        self.foldersUrls = foldersUrls
        #endif
        
        self.tools = tools
        
        self.setupFolders(from: self.foldersUrls)
        
        addPublishers()
        
        Task {
            await setupAppStoreService()
        }
    }
    
    deinit {
        // Clean up resources if needed
    }
    
    /// Applies a color to the current image, handling errors and updating the view.
    /// - Parameter color: The color to apply.
    public func apply(color: NSColor?) {
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
    public func apply(image: NSImage?, asset: PhotoAsset? = nil, item: PictureItem? = nil) {
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
        
        customizationTask = Task { [updateImage] in
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
    public func apply(emoji: Character?) {
        guard dropZoneViewModel.image.state != .none else {
            wrongAttempt += 1
            return
        }
        
        customizationTask?.cancel()
        
        customizationTask = Task { [emoji] in
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
    public func apply(action: ToolbarView.ToolbarViewDomain.Action) {
        switch action {
        case .undo:
            undoManager.undo()
        case .redo:
            undoManager.redo()
        case .colors:
            tools = .colors
        case .photos:
            tools = .photos
        case .emojis:
            tools = .emojis
        case .decals:
            tools = .decals
        case .spacer:
            break
        case .pictures:
            tools = .pictures
        case .webResources:
            tools = .webResources
        }
    }
    
    // Flags for skipping and applying selections
    private var skipSelectedColor = true
    private var skipSelectedPhoto = true
    private var skipSelectedPicture = true
    private var skipSelectedEmoji = true
    
    private var isApplyingSelectedColor = false
    private var isApplyingSelectedPhoto = false
    private var isApplyingSelectedPicture = false
    private var isApplyingSelectedEmoji = false
    
    /// Subscribes to view model publishers to handle updates for color, photo, picture, and emoji selections.
    private func addPublishers() {
        toolsColorsViewModel.$selectedColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] color in
                guard self?.skipSelectedColor == false else {
                    self?.skipSelectedColor = false
                    return
                }
                
                self?.isApplyingSelectedColor = true
                self?.apply(color: color)
                self?.isApplyingSelectedColor = false
            }
            .store(in: &cancellables)
        
        toolsPhotosViewModel.$selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard self?.skipSelectedPhoto == false else {
                    self?.skipSelectedPhoto = false
                    return
                }
                
                guard self?.isApplyingSelectedPicture == false else {
                    self?.isApplyingSelectedPicture = false
                    return
                }
                
                self?.isApplyingSelectedPhoto = true
                self?.toolsPicturesViewModel.selectedImage = nil
                self?.apply(image: image, asset: self?.toolsPhotosViewModel.selectedAsset)
            }
            .store(in: &cancellables)
        
        toolsPicturesViewModel.$selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard self?.skipSelectedPicture == false else {
                    self?.skipSelectedPicture = false
                    return
                }
                
                guard self?.isApplyingSelectedPhoto == false else {
                    self?.isApplyingSelectedPhoto = false
                    return
                }
                
                self?.isApplyingSelectedPicture = true
                self?.toolsPhotosViewModel.selectedImage = nil
                self?.apply(image: image?.image, item: image)
            }
            .store(in: &cancellables)
        
        toolsEmojisViewModel.$selectedEmoji
            .receive(on: DispatchQueue.main)
            .sink { [weak self] emoji in
                guard self?.skipSelectedEmoji == false else {
                    self?.skipSelectedEmoji = false
                    return
                }
                
                self?.isApplyingSelectedEmoji = true
                self?.apply(emoji: emoji)
                self?.isApplyingSelectedEmoji = false
            }
            .store(in: &cancellables)
    }
    
    /// Removes all cancellable publishers.
    private func removePublishers() {
        cancellables.removeAll()
    }
    
    // Lazy instantiation of view models used in tools and customization.
    private lazy var toolsColorsViewModel: ToolsColorsViewModel = .init()
    private lazy var toolsPhotosViewModel: ToolsPhotosViewModel = .init()
    private lazy var toolsPicturesViewModel: ToolsPicturesViewModel = .init(appSettings: appSettings, picturesFolderManager: picturesFolderManager)
    private lazy var toolsEmojisViewModel: ToolsEmojisViewModel = .init()
    private lazy var webResourcesViewModel: WebResourcesViewModel = .init()
    
    /// Provides the view for the selected tool.
    @ViewBuilder
    func toolsView() -> some View {
        switch tools {
        case .colors:
            ToolsColorsView()
                .environmentObject(toolsColorsViewModel)
        case .photos:
            ToolsPhotosView()
                .environmentObject(toolsPhotosViewModel)
        case .emojis:
            ToolsEmojisView()
                .environmentObject(toolsEmojisViewModel)
        case .decals:
            ToolsDecalsView()
        case .pictures:
            ToolsPicturesView()
                .environmentObject(toolsPicturesViewModel)
        case .webResources:
            WebResourcesView()
                .environmentObject(webResourcesViewModel)
        }
    }
    
    // Lazy instantiation of drop zone view model.
    private lazy var dropZoneViewModel: DropZoneViewModel = .init { [weak self] urls in
        self?.setupFolders(from: urls)
    } updateStateClosure: { [weak self] state in
        print("Set state to: \(state)")
        self?.customizingActionViewModel.update(state: state)
        self?.appliedStylesViewModel.update(state: state, imageCustomization: (self?.dropZoneViewModel.image.customisations)!)
        if state == .ready, let dropZone = self?.dropZoneViewModel, let index = self?.currentUndoItem, let undoItems = self?.undoItems.prefix(index + 1) {
            self?.undoItems = Array(undoItems)
            self?.undoItems.append(dropZone.image.undoItems)
            self?.add(index: index + 1)
        }
    }
    
    /// Provides the view for the icon folder.
    @ViewBuilder
    func iconFolderView() -> some View {
        DropZoneView()
            .environmentObject(dropZoneViewModel)
            .padding(.paddingSmall)
            .frame(width: width, height: width)
            .modifier(Shake(animatableData: CGFloat(wrongAttempt)))
    }
    
    // Lazy instantiation of applied styles view model.
    private lazy var appliedStylesViewModel: AppliedStylesViewModel = .init(toolsColorsViewModel: toolsColorsViewModel, toolsPhotosViewModel: toolsPhotosViewModel, toolsPicturesViewModel: toolsPicturesViewModel, toolsEmojisViewModel: toolsEmojisViewModel)
    
    /// Provides the view for the applied styles.
    @ViewBuilder
    func appliedStylesView() -> some View {
        AppliedStylesView()
            .environmentObject(appliedStylesViewModel)
            .frame(maxWidth: .infinity)
    }
    
    // Lazy instantiation of customizing action view model.
    private lazy var customizingActionViewModel: CustomizingActionViewModel = .init(actionClosure: { [weak self] in
        if self?.exportIconManager.canExport == true, let image = self?.dropZoneViewModel.image {
            self?.exportIconManager.export(image: image)
        } else {
            self?.showingExportAlert.toggle()
        }
    })
    
    @Published private var showingExportAlert = false
    @Published private var showingAppStoreSheet = false
    
    // Lazy instantiation of app store view model.
    private lazy var appStoreViewModel: AppStoreViewModel = .init(appStoreService: appStoreService, appSettings: appSettings) { [weak self] in
        self?.showingAppStoreSheet.toggle()
    }
    
    /// Provides the view for the customization folder.
    @ViewBuilder
    func customizeFolderView() -> some View {
        CustomizingActionView()
            .environmentObject(customizingActionViewModel)
            .frame(maxWidth: .infinity)
            .alert(isPresented: Binding<Bool>(
                get: { self.showingExportAlert },
                set: { newState in
                    self.showingExportAlert = newState
                }
            )) {
                Alert(title: Text(DomainViewConstantType.Localization.alertPurchaseTitle),
                      message: Text(DomainViewConstantType.Localization.alertPurchaseDescription),
                      primaryButton: .default(Text(DomainViewConstantType.Localization.alertPurchaseAction), action: {
                    self.showingAppStoreSheet.toggle()
                }), secondaryButton: .cancel(Text(DomainViewConstantType.Localization.alertPurchaseCancel)))
            }
            .sheet(isPresented: Binding<Bool>(
                get: { self.showingAppStoreSheet },
                set: { newState in
                    self.showingAppStoreSheet = newState
                }
            )) {
                AppStoreView()
                    .environmentObject(self.appStoreViewModel)
                    .frame(height: 544)
            }
    }
    
    /// Opens a folder in the drop zone view.
    public func openFolder() {
        dropZoneViewModel.openFolder()
    }
    
    /// Sets up folders based on the provided URLs, initializing the drop zone view model
    /// and updating the view with the folder's icon or image.
    /// - Parameter urls: The URLs of the folders to set up.
    func setupFolders(from urls: [URL]) {
        let folders = urls.filter { $0.isFolder }
        
        guard folders.isEmpty == false, let url = folders.first else {
            return
        }
        
        dropZoneViewModel.image.prepareForUpdate()
        
        Task {
            var icon: NSImage?
            
            let rsrcFile = url.appendingPathComponent("Icon\r/..namedfork/rsrc")
            if FileManager.default.fileExists(atPath: rsrcFile.path()) {
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
            
            undoItems.append(dropZoneViewModel.image.undoItems)
            currentUndoItem = .zero
            
            Task { @MainActor in
                foldersUrls = [url]
            }
        }
    }
    
    /// List of undo items for managing undo/redo actions.
    private var undoItems: [ImageUndoDto] = .init()
    private var currentUndoItem: Int = .zero
    
    /// Adds an undo item to the undo stack and updates the current index.
    /// - Parameter index: The index of the undo item to add.
    private func add(index: Int) {
        self.currentUndoItem = index
        
        undoManager.registerUndo(withTarget: self) { this in
            this.remove(index: index)
        }
        
        setupItemsForCurrentIndex()
    }
    
    /// Removes an undo item from the undo stack and updates the current index.
    /// - Parameter index: The index of the undo item to remove.
    private func remove(index: Int) {
        currentUndoItem = index - 1
        
        undoManager.registerUndo(withTarget: self) { this in
            this.add(index: index)
        }
        
        setupItemsForCurrentIndex()
    }
    
    /// Sets up the view state for the current undo item.
    private func setupItemsForCurrentIndex() {
        let image = undoItems[currentUndoItem]
        dropZoneViewModel.update(from: image)
        
        skipSelectedColor = true
        toolsColorsViewModel.selectedColor = image.customisations.selectedColor
        
        skipSelectedPhoto = true
        toolsPhotosViewModel.selectedImage = image.customisations.selectedPicture
        toolsPhotosViewModel.selectedAsset = image.customisations.selectedAsset
        
        skipSelectedPicture = true
        toolsPicturesViewModel.selectedImage = image.customisations.selectedPictureItem
        
        appliedStylesViewModel.update(state: .none, imageCustomization: dropZoneViewModel.image.customisations)
        
        updateHack.toggle()
    }
    
    /// Sets up the app store service and syncs store data.
    func setupAppStoreService() async {
        log.info("setup")
        
        do {
            try await appStoreService.syncStoreData()
        } catch {
            log.info("products fetch error: \(error.localizedDescription)")
        }
    }
}

extension HomeViewModel {
    static var preview: HomeViewModel {
        HomeViewModel(appStoreService: AppStorePreview())
    }
}
