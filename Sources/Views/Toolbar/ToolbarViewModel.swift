//
//  ToolbarViewModel.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import SwiftUI

/// ViewModel for managing the toolbar actions and interactions.
final class ToolbarViewModel: ObservableObject {
    /// Type alias for a callback that handles toolbar actions.
    typealias ToolbarViewModelActionCallback = (ToolbarView.ToolbarViewDomain.Action) -> Void

    private let actionCallback: ToolbarViewModelActionCallback
    let undoManager: UndoManager

    /// Indicates whether the user has made a tip purchase.
    @Published var hasTipped: Bool

    /// Initializes a `ToolbarViewModel` with an undo manager and a callback for toolbar actions.
    /// - Parameters:
    ///   - undoManager: The undo manager used to handle undo/redo operations.
    ///   - hasTipped: Whether the user has made a tip purchase.
    ///   - actionCallback: A closure that handles the toolbar actions.
    init(undoManager: UndoManager, hasTipped: Bool = false, actionCallback: @escaping ToolbarViewModelActionCallback) {
        self.undoManager = undoManager
        self.hasTipped = hasTipped
        self.actionCallback = actionCallback
    }

    /// Handles updates from the undo manager.
    /// - Parameter notification: The notification containing update information.
    @objc
    private func undoManagerUpdated(_: Foundation.Notification) {
        // updateHack.toggle()
    }

    /// Processes the given action and invokes the callback.
    /// - Parameter action: The action to process.
    func perform(_ action: ToolbarView.ToolbarViewDomain.Action) {
        actionCallback(action)
    }
}

extension ToolbarViewModel {
    /// A preview instance of `ToolbarViewModel` for SwiftUI previews.
    @MainActor
    static var preview: ToolbarViewModel {
        .init(undoManager: .init(), hasTipped: false) { _ in }
    }
}
