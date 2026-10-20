//
//  DropZoneViewProtocol.swift
//
//  Created on 05.11.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit

/// Delegate protocol for a Drop Files View.
@objc
public protocol DropZoneViewProtocol: NSObjectProtocol {
    /// Callback to the owner that the user has clicked the 'Select Files...' button.
    /// - Parameter sender: The `DropZoneNSView` instance that initiated the action.
    @objc
    optional func dropFilesViewWantsSelectFiles(_ sender: DropZoneNSView)

    /// Asks the delegate to validate the URLs that the user has dragged onto the control.
    /// - Parameters:
    ///   - sender: The `DropZoneNSView` instance that initiated the action.
    ///   - validateFiles: The URLs to be validated.
    /// - Returns: The drag operation for the dragged files. Return `[]` to fail the drag.
    func dropFilesView(_ sender: DropZoneNSView, validateFiles: [URL]) -> NSDragOperation

    /// Handles the files that have been dropped on the view.
    /// - Parameters:
    ///   - sender: The `DropZoneNSView` instance that initiated the action.
    ///   - files: The URLs that were dropped.
    /// - Returns: `true` if the drop action was successful, otherwise `false`.
    func dropFilesView(_ sender: DropZoneNSView, didDropFiles files: [URL]) -> Bool

    /// Called when files enter the drop zone.
    /// - Parameter sender: The `DropZoneNSView` instance that triggered the event.
    func dropFilesViewEnterZone(_ sender: DropZoneNSView)

    /// Called when files exit the drop zone.
    /// - Parameter sender: The `DropZoneNSView` instance that triggered the event.
    func dropFilesViewExitZone(_ sender: DropZoneNSView)
}
