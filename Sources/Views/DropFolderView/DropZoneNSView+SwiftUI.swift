//
//  DropZoneNSView+SwiftUI.swift
//  colir
//
//  Created by Vitalii P on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

public extension DropZoneNSView {
    /// A SwiftUI wrapper for DropFolderView
    struct SwiftUI {
        public typealias NSViewType = DropZoneNSView
        
        // MARK: Types
        
        /// User has dragged files into the view and require drop validation. Return the drag operation supported for the dragged files,
        /// or [] to disallow the drag.
        public typealias ValidateFuncType = (([URL]) -> NSDragOperation)
        
        /// Files dropped callback block. Return true if the block has successfully handled the drop, false otherwise.
        public typealias DropFuncType = (([URL]) -> Bool)
        
        /// Select files callback type
        public typealias SelectFuncType = (() -> Void)
        
        /// Select files callback type
        public typealias ZoneFuncType = ((Bool) -> Void)
        
        // MARK: - Properties
        
        /// Enable or disable the control
        public let isEnabled: Bool
        
        /// Allow dropping multiple files
        public let allowsMultipleDrop: Bool
        
        // MARK: - Callbacks
        
        /// Called when the user drags some files into the view.
        public let validateFiles: ValidateFuncType?
        
        /// Called when the user drops files on the view
        public let dropFiles: DropFuncType?
        
        /// Called when the user clicks the 'select files' button
        public let selectFiles: SelectFuncType?
        
        /// Called when the user clicks the 'select files' button
        public let enterZone: ZoneFuncType?
        
        /// Initializer
        ///
        /// Needs to be provided as (by default) a default initializer is marked as internal
        public init(
            isEnabled: Bool = true,
            allowsMultipleDrop: Bool = true,
            validateFiles: ValidateFuncType? = nil,
            enterZone: ZoneFuncType? = nil,
            dropFiles: DropFuncType? = nil,
            selectFiles: SelectFuncType? = nil
        ) {
            self.isEnabled = isEnabled
            self.allowsMultipleDrop = allowsMultipleDrop
            self.validateFiles = validateFiles
            self.enterZone = enterZone
            self.dropFiles = dropFiles
            self.selectFiles = selectFiles
        }
    }
}

// MARK: - Coordinator

/// Convenience function for optionally updating a value
/// - Parameters:
///   - result: The property to optionally update if 'val' is not equal to its value
///   - val: The value to check against
@inlinable internal func UpdateIfNotEqual<T>(_ result: inout T, _ val: T) where T: Equatable {
    guard result != val else { return }
    result = val
}

extension DropZoneNSView.SwiftUI: NSViewRepresentable {
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeNSView(context: Context) -> DropZoneNSView {
        let view = DropZoneNSView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dropDelegate = context.coordinator
        
        return view
    }
    
    public func updateNSView(_ nsView: DropZoneNSView, context _: Context) {
        UpdateIfNotEqual(&nsView.isEnabled, self.isEnabled)
        UpdateIfNotEqual(&nsView.allowsMultipleDrop, self.allowsMultipleDrop)
    }
}

// MARK: - Delegate handling

public extension DropZoneNSView.SwiftUI {
    class Coordinator: NSObject, DropZoneViewProtocol {
        public func dropFilesViewEnterZone(_ sender: DropZoneNSView) {
            self.parent.enterZone?(true)
        }
        
        public func dropFilesViewExitZone(_ sender: DropZoneNSView) {
            self.parent.enterZone?(false)
        }
        
        let parent: DropZoneNSView.SwiftUI
        init(_ dropView: DropZoneNSView.SwiftUI) {
            self.parent = dropView
        }
        
        public func dropFilesView(_: DropZoneNSView, validateFiles: [URL]) -> NSDragOperation {
            return self.parent.validateFiles?(validateFiles) ?? []
        }
        
        public func dropFilesView(_: DropZoneNSView, didDropFiles files: [URL]) -> Bool {
            return self.parent.dropFiles?(files) ?? false
        }
        
        public func dropFilesViewWantsSelectFiles(_: DropZoneNSView) {
            self.parent.selectFiles?()
        }
    }
}
