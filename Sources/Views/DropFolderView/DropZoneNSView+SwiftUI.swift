//
//  DropZoneNSView+SwiftUI.swift
//
//  Created on 07.11.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import SwiftUI

extension DropZoneNSView {
    /// A SwiftUI wrapper for DropZoneNSView
    public struct SwiftUI {
        public typealias NSViewType = DropZoneNSView

        // MARK: - Types

        /// Closure for validating files being dragged into the view.
        /// - Parameter urls: The dragged file URLs.
        /// - Returns: The drag operation supported for the dragged files.
        public typealias ValidateFuncType = ([URL]) -> NSDragOperation

        /// Closure for handling files dropped on the view.
        /// - Parameter urls: The dropped file URLs.
        /// - Returns: `true` if the drop was successfully handled, `false` otherwise.
        public typealias DropFuncType = ([URL]) -> Bool

        /// Closure for handling the 'select files' button click.
        public typealias SelectFuncType = () -> Void

        /// Closure for handling entry/exit of the drop zone.
        /// - Parameter isEntering: `true` if entering the zone, `false` if exiting.
        public typealias ZoneFuncType = (Bool) -> Void

        // MARK: - Properties

        /// Determines if the control is enabled.
        public let isEnabled: Bool

        /// Allows dropping multiple files.
        public let allowsMultipleDrop: Bool

        // MARK: - Callbacks

        /// Callback for when files are dragged into the view.
        public let validateFiles: ValidateFuncType?

        /// Callback for when files are dropped on the view.
        public let dropFiles: DropFuncType?

        /// Callback for the 'select files' button click.
        public let selectFiles: SelectFuncType?

        /// Callback for when the drop zone is entered or exited.
        public let enterZone: ZoneFuncType?

        /// Initializer for setting up the SwiftUI wrapper.
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

/// Convenience function for updating a value if it differs from the existing value.
@inlinable
func UpdateIfNotEqual<T>(_ result: inout T, _ val: T) where T: Equatable {
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
        UpdateIfNotEqual(&nsView.isEnabled, isEnabled)
        UpdateIfNotEqual(&nsView.allowsMultipleDrop, allowsMultipleDrop)
    }
}

// MARK: - Delegate Handling

extension DropZoneNSView.SwiftUI {
    public final class Coordinator: NSObject, DropZoneViewProtocol {
        let parent: DropZoneNSView.SwiftUI

        init(_ dropView: DropZoneNSView.SwiftUI) {
            parent = dropView
        }

        public func dropFilesViewEnterZone(_: DropZoneNSView) {
            parent.enterZone?(true)
        }

        public func dropFilesViewExitZone(_: DropZoneNSView) {
            parent.enterZone?(false)
        }

        public func dropFilesView(_: DropZoneNSView, validateFiles: [URL]) -> NSDragOperation {
            parent.validateFiles?(validateFiles) ?? []
        }

        public func dropFilesView(_: DropZoneNSView, didDropFiles files: [URL]) -> Bool {
            parent.dropFiles?(files) ?? false
        }

        public func dropFilesViewWantsSelectFiles(_: DropZoneNSView) {
            parent.selectFiles?()
        }
    }
}
