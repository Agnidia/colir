//
//  ToolbarViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

final class ToolbarViewModel: ObservableObject {
    
    typealias ToolbarViewModelActionCallback = (ToolbarView.ToolbarViewDomain.Action) -> ()
    
    private let actionCallback: ToolbarViewModelActionCallback
    
    private let undoManager: UndoManager
    
    private var currentToolAction = ToolbarView.ToolbarViewDomain.Action.colors
    
    @Published var updateHack = true
    
    init(undoManager: UndoManager, actionCallback: @escaping ToolbarViewModelActionCallback) {
        self.undoManager = undoManager
        self.actionCallback = actionCallback
        
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    private func addObservers() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(undoManagerUpdated), name: .NSUndoManagerDidUndoChange, object: undoManager)
        
        nc.addObserver(self, selector: #selector(undoManagerUpdated), name: .NSUndoManagerDidRedoChange, object: undoManager)
    }
    
    private func removeObservers() {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: .NSUndoManagerDidUndoChange, object: undoManager)
        nc.removeObserver(self, name: .NSUndoManagerDidRedoChange, object: undoManager)
    }
    
    @objc private func undoManagerUpdated(_ notification: Foundation.Notification) {
        updateHack.toggle()
    }
    
    @ViewBuilder
    /// Construct Toolbar Item view for each action
    /// - Parameter action: Action from ToolbarViewDomain
    /// - Returns: SwiftUI view
    ///
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
    
    /// Process action and send it to super object
    /// - Parameter action: Action from ToolbarViewDomain
    ///
    private func perform(_ action: ToolbarView.ToolbarViewDomain.Action) {
        actionCallback(action)
    }
}

extension ToolbarViewModel {
    static var preview: ToolbarViewModel = .init(undoManager: .init()) { _ in }
}
