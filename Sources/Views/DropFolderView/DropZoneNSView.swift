//
//  DropZoneNSView.swift
//
//  Created on 07.11.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit

/// A view that supports dropping files
@objc
public final class DropZoneNSView: NSView {
    // MARK: - Public Accessors

    /// Enable or disable the control
    public dynamic var isEnabled: Bool = true

    /// The drop delegate.
    public var dropDelegate: DropZoneViewProtocol?

    /// Do we support dropping multiple files at once?
    public var allowsMultipleDrop: Bool = true

    // MARK: - Initialization

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configureControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureControl()
    }

    // MARK: - Action Callbacks

    @objc
    func selectFiles(_: Any) {
        guard let userSelectedFiles = dropDelegate?.dropFilesViewWantsSelectFiles else { return }

        userSelectedFiles(self)
    }
}

// MARK: - UI Layout

extension DropZoneNSView {
    private func configureControl() {
        wantsLayer = true
        registerForDraggedTypes([.fileURL])
    }
}

// MARK: - Drag and Drop

extension DropZoneNSView {
    // Called when the user has dragged a file
    override public func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard isEnabled, let files = filesOnPasteboard(for: sender) else {
            return false
        }

        return dropDelegate?.dropFilesView(self, validateFiles: files) != []
    }

    // When the user has dragged INTO the view
    override public func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let files = filesOnPasteboard(for: sender), !files.isEmpty else {
            return []
        }

        if !allowsMultipleDrop, files.count != 1 {
            return []
        }

        let dragOperation = dropDelegate?.dropFilesView(self, validateFiles: files) ?? []

        if !dragOperation.isEmpty {
            dropDelegate?.dropFilesViewEnterZone(self)
        }

        return dragOperation
    }

    // When the user has dragged OUT of the view or drag is cancelled
    override public func draggingExited(_: NSDraggingInfo?) {
        dropDelegate?.dropFilesViewExitZone(self)
    }

    // Perform the drag operation
    override public func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let dropDelegate, let files = filesOnPasteboard(for: sender) else {
            return false
        }

        dropDelegate.dropFilesViewExitZone(self)

        return dropDelegate.dropFilesView(self, didDropFiles: files)
    }

    // MARK: - Private

    private func filesOnPasteboard(for sender: NSDraggingInfo) -> [URL]? {
        guard let objects = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], !objects.isEmpty else {
            return nil
        }

        return objects
    }
}
