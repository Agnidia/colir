//
//  ToolbarViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

import SwiftUI

/// ViewModel for managing the toolbar actions and interactions.
final class ToolbarViewModel: ObservableObject {
    
    /// Type alias for a callback that handles toolbar actions.
    typealias ToolbarViewModelActionCallback = (ToolbarView.ToolbarViewDomain.Action) -> ()
    
    private let actionCallback: ToolbarViewModelActionCallback
    private let undoManager: UndoManager
    
    /// The current tool action selected.
    private var currentToolAction = ToolbarView.ToolbarViewDomain.Action.colors
    
    /// A flag to trigger view updates.
    @Published var updateHack = true
    
    /// Initializes a `ToolbarViewModel` with an undo manager and a callback for toolbar actions.
    /// - Parameters:
    ///   - undoManager: The undo manager used to handle undo/redo operations.
    ///   - actionCallback: A closure that handles the toolbar actions.
    init(undoManager: UndoManager, actionCallback: @escaping ToolbarViewModelActionCallback) {
        self.undoManager = undoManager
        self.actionCallback = actionCallback
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    /// Adds observers to monitor changes in the undo manager.
    private func addObservers() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(undoManagerUpdated), name: .NSUndoManagerDidUndoChange, object: undoManager)
        nc.addObserver(self, selector: #selector(undoManagerUpdated), name: .NSUndoManagerDidRedoChange, object: undoManager)
    }
    
    /// Removes observers for the undo manager.
    private func removeObservers() {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: .NSUndoManagerDidUndoChange, object: undoManager)
        nc.removeObserver(self, name: .NSUndoManagerDidRedoChange, object: undoManager)
    }
    
    /// Handles updates from the undo manager.
    /// - Parameter notification: The notification containing update information.
    @objc private func undoManagerUpdated(_ notification: Foundation.Notification) {
        updateHack.toggle()
    }
    
    /// Constructs a toolbar item view for a given action.
    /// - Parameter action: The action for which to create a toolbar item.
    /// - Returns: A SwiftUI view for the toolbar item.
    @MainActor
    @ViewBuilder
    func item(for action: ToolbarView.ToolbarViewDomain.Action) -> some View {
        if updateHack {
            EmptyView()
        }
        
        switch action {
        case .colors, .photos, .emojis, .decals, .pictures, .webResources:
            Button {
                self.currentToolAction = action
                self.perform(action)
            } label: {
                Label(action.title, systemImage: action.icon)
                    .font(.title3)
            }
            .background(RoundedRectangle(cornerRadius: .radiusThin)
                .fill(currentToolAction == action ? Color.accent.opacity(0.4) : .clear))
            .help(action.helpTitle)
        case .spacer:
            Spacer()
        case .undo:
            HStack {
                Spacer()
                Button { self.perform(action) } label: {
                    Label(action.title, systemImage: action.icon)
                        .font(.title3)
                }
                .help(action.helpTitle)
                .disabled(undoManager.canUndo == false)
            }
            .frame(width: 84)
        case .redo:
            HStack {
                Button { self.perform(action) } label: {
                    Label(action.title, systemImage: action.icon)
                        .font(.title3)
                }
                .help(action.helpTitle)
                .disabled(undoManager.canRedo == false)
                
                Spacer()
                
                Divider()
            }
            .frame(width: 54)
        }
    }
    
    /// Processes the given action and invokes the callback.
    /// - Parameter action: The action to process.
    private func perform(_ action: ToolbarView.ToolbarViewDomain.Action) {
        actionCallback(action)
    }
}

extension ToolbarViewModel {
    /// A preview instance of `ToolbarViewModel` for SwiftUI previews.
    static var preview: ToolbarViewModel {
        .init(undoManager: .init()) { _ in }
    }
}
