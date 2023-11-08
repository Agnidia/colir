//
//  HomeViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 24.07.2023.
//

import AppKit
import SwiftUI
import SwiftCommons
import Combine

final class HomeViewModel: ObservableObject {
    
    enum Tools: Equatable {
        case colors
        case photos
        case pictures
        case emojis
        case decals
        case webResources
    }
    
    @Published private(set) var undoManager: UndoManager
    
    private var appSettings: AppSettingsProtocol
    
    private lazy var rsrcFileParser = RSRCFileParser()
    
    private var foldersUrls: [URL]
    
    private var folderImage: NSImage?
    
    var width: CGFloat {
        236
    }
    
    @Published private var tools: Tools
    
    @Published var wrongAttempt: Int = 0
    
    private var customizationTask: Task<(), Never>?
    
    /// Collection of cancellable publishers to clean up when done.
    private var cancellables = Set<AnyCancellable>()
    
    init(undoManager: UndoManager = .init(),
         appSettings: AppSettingsProtocol = AppSettings(),
         foldersUrls: [URL] = [],
         folderImage: NSImage? = nil,
         tools: Tools = .colors) {
        self.undoManager = undoManager
        self.appSettings = appSettings
        self.foldersUrls = foldersUrls
        self.folderImage = folderImage
        self.tools = tools
        
        addPublishers()
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
        
        dropZoneViewModel.customizations.selectedColor = color
        
        customizationTask?.cancel()
        
        customizationTask = Task {
            do {
                try await dropZoneViewModel.image.updateCustomization(customizations: dropZoneViewModel.customizations)
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
        
        dropZoneViewModel.customizations.selectedImage = image
        customizationTask?.cancel()
        
        customizationTask = Task {
            do {
                try await dropZoneViewModel.image.updateCustomization(customizations: dropZoneViewModel.customizations)
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
    
    private func addPublishers() {
        toolsColorsViewModel.$selectedColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] color in
                self?.apply(color: color)
            }
            .store(in: &cancellables)
    }
    
    private func removePublishers() {
        cancellables.removeAll()
    }
    
    private lazy var toolsColorsViewModel: ToolsColorsViewModel = .init()
    private lazy var toolsPhotosViewModel: ToolsPhotosViewModel = .init()
    private lazy var toolsEmojisViewModel: ToolsEmojisViewModel = .init()
    private lazy var toolsPicturesViewModel: ToolsPicturesViewModel = .init(appSettings: appSettings)
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
    
    private lazy var customizingActionViewModel: CustomizingActionViewModel = .init()
    
    @ViewBuilder
    func customizeFolderView() -> some View {
        CustomizingActionView()
            .environmentObject(customizingActionViewModel)
            .frame(maxWidth: .infinity)
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
            
            Task { @MainActor in
                foldersUrls = [url]
                add(image: icon)
            }
        }
    }
    
    func add(image: NSImage) {
        undoManager.registerUndo(withTarget: self) { this in
            this.remove(image: image)
        }
        folderImage = image
    }
    
    func remove(image: NSImage) {
        undoManager.registerUndo(withTarget: self) { this in
            this.add(image: image)
        }
        folderImage = image
    }
}

extension HomeViewModel {
    static var preview: HomeViewModel {
        HomeViewModel()
    }
}
