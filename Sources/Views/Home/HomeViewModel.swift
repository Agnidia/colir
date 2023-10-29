//
//  HomeViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 24.07.2023.
//

import AppKit
import SwiftUI
import SwiftCommons

final class HomeViewModel: ObservableObject {
    
    private enum Tools: Equatable {
        case colors
        case photos
        case pictures
        case emojis
        case decals
        case webResources
    }
    
    @Published private(set) var undoManager = UndoManager()
    
    private lazy var rsrcFileParser = RSRCFileParser()
    
    @Published private(set) var foldersUrls: [URL] = .init()
    
    @Published private(set) var folderImage: NSImage = NSImage(systemSymbolName: "folder.badge.plus", accessibilityDescription: nil)!
    
    @Published private var tools: Tools = .colors
    
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
    
    @ViewBuilder
    func toolsView() -> some View {
        switch tools {
        case .colors:
            ToolsColorsView()
                .environmentObject(ToolsColorsViewModel())
        case .photos:
            ToolsPhotosView()
                .environmentObject(ToolsPhotosViewModel())
        case .emojis:
            ToolsEmojisView()
                .environmentObject(ToolsEmojisViewModel())
        case .decals:
            ToolsDecalsView()
        case .pictures:
            ToolsPicturesView()
                .environmentObject(ToolsPicturesViewModel(appSettings: AppSettings()))
        case .webResources:
            WebResourcesView()
                .environmentObject(WebResourcesViewModel())
        }
    }
    
    func openFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.prompt = NSLocalizedString("Choose", comment: "")
        panel.message = NSLocalizedString("Choose folder to colorise it", comment: "")
        let response = panel.runModal()
        
        guard let url = response == .OK ? panel.url : nil else {
            return
        }
        
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
        
        foldersUrls = [url]
        add(image: icon)
    }
    
    func urlsHasFolders(urls: [URL]) -> Bool {
        !urls.filter { $0.isFolder }.isEmpty
    }
    
    func setupFolders(from urls: [URL]) {
        let folders = urls.filter { $0.isFolder }
        guard folders.isEmpty == false, let folder = folders.first, let icon = folder.icon else {
            return
        }
        
        foldersUrls = [folder]
        add(image: icon)
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
