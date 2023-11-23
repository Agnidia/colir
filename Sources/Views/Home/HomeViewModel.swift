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

final class HomeViewModel: ObservableObject, DomainViewConstantProtocol {
    let viewSettings: HomeViewDomain = .init()
    
    typealias DomainViewConstantType = HomeViewDomain
    
    enum Tools: Equatable {
        case colors
        case photos
        case pictures
        case emojis
        case decals
        case webResources
    }
    
    private(set) var undoManager: UndoManager
    
    let picturesFolderManager: PicturesFolderManagerProtocol
    
    private var appSettings: AppSettingsProtocol
    
    private var exportIconManager: ExportIconManagerProtocol
    
    private var appStoreService: AppStoreProtocol
    
    private lazy var rsrcFileParser = RSRCFileParser()
    
    private let log: LogProtocol
    
    private var foldersUrls: [URL]
        
    var width: CGFloat {
        236
    }
    
    @Published private var tools: Tools
    
    @Published var wrongAttempt: Int = 0
    
    @Published var updateHack = true
    
    private var customizationTask: Task<(), Never>?
    
    /// Collection of cancellable publishers to clean up when done.
    private var cancellables = Set<AnyCancellable>()
    
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
        
    }
    
    public func apply(color: NSColor?) {
        guard dropZoneViewModel.image.state != .none else {
            withAnimation(.default) {
                wrongAttempt += 1
            }
            return
        }
                
        customizationTask?.cancel()
        
        customizationTask = Task {
            await dropZoneViewModel.image.customizations.apply(color: color)
            
            do {
                try await dropZoneViewModel.image.update(customizations: dropZoneViewModel.image.customizations)
            } catch {
                print("task canceled")
            }
        }
    }
    
    public func apply(image: NSImage?) {
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
            await dropZoneViewModel.image.customizations.apply(picture: updateImage)
            
            do {
                try await dropZoneViewModel.image.update(customizations: dropZoneViewModel.image.customizations)
            } catch {
                print("task canceled")
            }
        }
    }
    
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
    
    private var skipFirstSelectedColor = true
    private var skipFirstSelectedPhoto = true
    private var skipFirstSelectedImage = true
    
    private var isApplyingSelectedColor = false
    private var isApplyingSelectedPhoto = false
    private var isApplyingSelectedImage = false
    
    private func addPublishers() {
        toolsColorsViewModel.$selectedColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] color in
                guard self?.skipFirstSelectedColor == false else {
                    self?.skipFirstSelectedColor = false
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
                guard self?.skipFirstSelectedPhoto == false else {
                    self?.skipFirstSelectedPhoto = false
                    return
                }
                
                guard self?.isApplyingSelectedImage == false else {
                    self?.isApplyingSelectedImage = false
                    return
                }
                
                self?.isApplyingSelectedPhoto = true
                self?.toolsPicturesViewModel.selectedImage = nil
                self?.apply(image: image)
            }
            .store(in: &cancellables)
        
        toolsPicturesViewModel.$selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard self?.skipFirstSelectedImage == false else {
                    self?.skipFirstSelectedImage = false
                    return
                }
                
                guard self?.isApplyingSelectedPhoto == false else {
                    self?.isApplyingSelectedPhoto = false
                    return
                }
                
                self?.isApplyingSelectedImage = true
                self?.toolsPhotosViewModel.selectedImage = nil
                self?.apply(image: image?.image)
            }
            .store(in: &cancellables)
    }
    
    private func removePublishers() {
        cancellables.removeAll()
    }
    
    private lazy var toolsColorsViewModel: ToolsColorsViewModel = .init()
    private lazy var toolsPhotosViewModel: ToolsPhotosViewModel = .init()
    private lazy var toolsEmojisViewModel: ToolsEmojisViewModel = .init()
    private lazy var toolsPicturesViewModel: ToolsPicturesViewModel = .init(appSettings: appSettings, picturesFolderManager: picturesFolderManager)
    private lazy var webResourcesViewModel: WebResourcesViewModel = .init()
    
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
    
    private lazy var dropZoneViewModel: DropZoneViewModel = .init { [weak self] urls in
        self?.setupFolders(from: urls)
    } updateStateClosure: { [weak self] state in
        print("Set state to: \(state)")
        self?.customizingActionViewModel.update(state: state)
        if state == .ready, let dropZone = self?.dropZoneViewModel, let index = self?.currentUndoItem, let undoItems = self?.undoItems.prefix(index + 1) {
            self?.undoItems = Array(undoItems)
            self?.undoItems.append(dropZone.image.undoItems)
            self?.add(index: index + 1)
        }
    }
    
    @ViewBuilder
    func iconFolderView() -> some View {
        DropZoneView()
            .environmentObject(dropZoneViewModel)
            .padding(8)
            .frame(width: width, height: width)
            .modifier(Shake(animatableData: CGFloat(wrongAttempt)))
    }
    
    private lazy var appliedStylesViewModel: AppliedStylesViewModel = .init()
    
    @ViewBuilder
    func appliedStylesView() -> some View {
        AppliedStylesView()
            .environmentObject(appliedStylesViewModel)
            .frame(maxWidth: .infinity)
    }
    
    private lazy var customizingActionViewModel: CustomizingActionViewModel = .init(actionClosure: { [weak self] in
        if self?.exportIconManager.canExport == true, let image = self?.dropZoneViewModel.image {
            self?.exportIconManager.export(image: image)
        } else {
            self?.showingExportAlert.toggle()
        }
    })
    
    @Published private var showingExportAlert = false
    @Published private var showingAppStoreSheet = false
    
    private lazy var appStoreViewModel: AppStoreViewModel = .init(appStoreService: appStoreService, appSettings: appSettings) { [weak self] in
        self?.showingAppStoreSheet.toggle()
    }
    
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
            }
    }
    
    public func openFolder() {
        dropZoneViewModel.openFolder()
    }
    
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
            currentUndoItem = 0
            
            Task { @MainActor in
                foldersUrls = [url]
            }
        }
    }
    
    private var undoItems: [ImageUndoDto] = .init()
    private var currentUndoItem: Int = 0
    
    private func add(index: Int) {
        self.currentUndoItem = index
        
        undoManager.registerUndo(withTarget: self) { this in
            this.remove(index: index)
        }
        
        setupItemsForCurrentIndex()
    }
    
    private func remove(index: Int) {
        currentUndoItem = index - 1
        
        undoManager.registerUndo(withTarget: self) { this in
            this.add(index: index)
        }
        
        setupItemsForCurrentIndex()
    }
    
    private func setupItemsForCurrentIndex() {
        let image = undoItems[currentUndoItem]
        dropZoneViewModel.update(from: image)
        
        skipFirstSelectedColor = true
        toolsColorsViewModel.selectedColor = image.customizations.selectedColor
        
        updateHack.toggle()
    }
    
    /// main setup of base objects
    ///
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
