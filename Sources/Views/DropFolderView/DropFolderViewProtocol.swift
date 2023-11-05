//
//  DropFolderViewProtocol.swift
//  colir
//
//  Created by Vitalii P on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

/// Delegate protocol for a Drop Files View.
@objc public protocol DropFolderViewProtocol: NSObjectProtocol {
    /// Callback to the owner that the user has clicked the 'Select Files...' button
    @objc optional func dropFilesViewWantsSelectFiles(_ sender: DropFolderView)

    /// Ask the delegate to validate the urls that the user has dragged onto the control
    /// - Parameters:
    ///   - sender: The drop files view that initiated the action
    ///   - validateFiles: The urls to be validated
    /// - Returns the drag operation for the dragged files. Return [] to fail the drag
    func dropFilesView(_ sender: DropFolderView, validateFiles: [URL]) -> NSDragOperation

    /// The files have been dropped on the view
    /// - Parameters:
    ///   - sender: The drop files view that initiated the action
    ///   - files: The urls that were dropped
    /// - Returns true if the drop action was successful
    func dropFilesView(_ sender: DropFolderView, didDropFiles files: [URL]) -> Bool
}
