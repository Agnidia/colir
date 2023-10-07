//
//  ToolbarViewModel.swift
//  colir
//
//  Created by Vitalii P on 23.07.2023.
//

import SwiftUI

final class ToolbarViewModel: ObservableObject {
    
    typealias ToolbarViewModelActionCallback = (ToolbarView.ToolbarViewDomain.Action) -> ()
    
    private let actionCallback: ToolbarViewModelActionCallback
    
    private let undoManager: UndoManager
    
    private var currentToolAction = ToolbarView.ToolbarViewDomain.Action.colors
    
    init(undoManager: UndoManager, actionCallback: @escaping ToolbarViewModelActionCallback) {
        self.undoManager = undoManager
        self.actionCallback = actionCallback
    }
    
    @ViewBuilder
    /// Construct Toolbar Item view for each action
    /// - Parameter action: Action from ToolbarViewDomain
    /// - Returns: SwiftUI view
    ///
    func item(for action: ToolbarView.ToolbarViewDomain.Action) -> some View {
        switch action {
        case .colors, .photos, .emojies, .decals, .pictures:
            Button {
                self.currentToolAction = action
                self.perform(action)
            } label: {
                Label(action.title, systemImage: action.icon)
            }
            .background(RoundedRectangle(cornerRadius: 6)
                .fill(currentToolAction == action ? Color(white: 0.3) : .clear))
            .help(action.helpTitle)
        case .spacer:
            Spacer()
        case .undo:
            HStack {
                Spacer(minLength: 30)
                Button { self.perform(action) } label: {
                    Label(action.title, systemImage: action.icon)
                }
                .help(action.helpTitle)
                .disabled(undoManager.canUndo == false)
            }
        case .redo:
            HStack {
                Button { self.perform(action) } label: {
                    Label(action.title, systemImage: action.icon)
                }
                .help(action.helpTitle)
                .disabled(undoManager.canRedo == false)
                Spacer(minLength: 30)
                Divider()
            }
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
