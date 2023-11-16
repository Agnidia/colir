//
//  DropZoneView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

/// A view that support dropping files
@objc public class DropZoneNSView: NSView {
    // MARK: - Public accessors
    
    /// Enable or disable the control
    public dynamic var isEnabled: Bool = true
    
    /// The drop delegate.
    public var dropDelegate: DropZoneViewProtocol?
    
    /// Do we support dropping multiple files at once?
    var allowsMultipleDrop: Bool = true
    
    // MARK: - Initialization
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configureControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureControl()
    }
}

// MARK: - Action callbacks

extension DropZoneNSView {
    @objc func selectFiles(_: Any) {
        guard let userSelectedFiles = dropDelegate?.dropFilesViewWantsSelectFiles else { return }
        
        userSelectedFiles(self)
    }
}

// MARK: - UI Layout

fileprivate extension DropZoneNSView {
    
    private func configureControl() {
        wantsLayer = true
        
        registerForDraggedTypes([.fileURL])
    }
}

// MARK: - Drag and drop

public extension DropZoneNSView {
    
    // Called when the user has dropped a file
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if isEnabled, let dropDelegate, let files = filesOnPasteboard(for: sender) {
            return dropDelegate.dropFilesView(self, validateFiles: files) != []
        }
        
        return false
    }
    
    // When the user has dragged INTO the view
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        // If there are no files on the pasteboard then do nothing
        guard let files = filesOnPasteboard(for: sender) else {
            return []
        }
        
        // If we are in single select and there are multiple files then don't allow drop
        if !allowsMultipleDrop, files.count != 1 {
            return []
        }
        
        guard let dropDelegate else {
            return []
        }
        
        let dragOperation: NSDragOperation = dropDelegate.dropFilesView(self, validateFiles: files)
        
        guard dragOperation.isEmpty == false else {
            return []
        }
        
        dropDelegate.dropFilesViewEnterZone(self)
        
        return dragOperation
    }
    
    // When the user has dragged OUT of the view or drag is cancelled
    
    override func draggingExited(_: NSDraggingInfo?) {
        guard let dropDelegate else {
            return
        }
        
        dropDelegate.dropFilesViewExitZone(self)
    }
    
    // Perform the drag operation
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let dropDelegate, let files = filesOnPasteboard(for: sender) else {
            return false
        }
        
        dropDelegate.dropFilesViewExitZone(self)
        
        return dropDelegate.dropFilesView(self, didDropFiles: files)
    }
    
    //MARK: - Private
    
    private func filesOnPasteboard(for sender: NSDraggingInfo) -> [URL]? {
        guard let objs = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] else {
            return nil
        }
        
        let urls = objs.compactMap { $0 }
        
        guard urls.isEmpty == false else {
            return nil
        }
        
        return urls
    }
}
