//
//  ToolbarViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// ViewModel for managing the toolbar actions and interactions.
final class ToolbarViewModel: ObservableObject {
    /// Type alias for a callback that handles toolbar actions.
    typealias ToolbarViewModelActionCallback = (ToolbarView.ToolbarViewDomain.Action) -> Void

    private let actionCallback: ToolbarViewModelActionCallback
    let undoManager: UndoManager

    /// Initializes a `ToolbarViewModel` with an undo manager and a callback for toolbar actions.
    /// - Parameters:
    ///   - undoManager: The undo manager used to handle undo/redo operations.
    ///   - actionCallback: A closure that handles the toolbar actions.
    init(undoManager: UndoManager, actionCallback: @escaping ToolbarViewModelActionCallback) {
        self.undoManager = undoManager
        self.actionCallback = actionCallback
    }

    /// Handles updates from the undo manager.
    /// - Parameter notification: The notification containing update information.
    @objc private func undoManagerUpdated(_: Foundation.Notification) {
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
        .init(undoManager: .init()) { _ in }
    }
}
