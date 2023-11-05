//
//  DropFolderView.swift
//  colir
//
//  Created by Vitalii P on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

public extension DropFolderView {
    /// A SwiftUI wrapper for DropFolderView
    struct SwiftUI {
        public typealias NSViewType = DropFolderView

        /// Display properties for the view.
        public struct DisplayProperties {
            /// Is the border animated when a valid drop is available?
            let isAnimated: Bool
            /// Draw a dotted border around the outside of the view
            let isBordered: Bool
            /// The corner radius for the border
            let cornerRadius: CGFloat
            /// The border line width
            let lineWidth: CGFloat

            public init(
                isBordered: Bool = true,
                isAnimated: Bool = true,
                lineWidth: CGFloat = 2,
                cornerRadius: CGFloat = 4) {
                self.isBordered = isBordered
                self.isAnimated = isAnimated
                self.cornerRadius = cornerRadius
                self.lineWidth = lineWidth
            }
        }

        // MARK: Types

        /// User has dragged files into the view and require drop validation. Return the drag operation supported for the dragged files,
        /// or [] to disallow the drag.
        public typealias ValidateFuncType = (([URL]) -> NSDragOperation)

        /// Files dropped callback block. Return true if the block has successfully handled the drop, false otherwise.
        public typealias DropFuncType = (([URL]) -> Bool)

        /// Select files callback type
        public typealias SelectFuncType = (() -> Void)

        // MARK: - Properties

        /// The display properties for the view
        public let displayProperties: DisplayProperties

        /// Enable or disable the control
        public let isEnabled: Bool

        /// Allow dropping multiple files
        public let allowsMultipleDrop: Bool

        /// The icon for the control.  If nil, no icon is displayed
        public let icon: NSImage?

        /// The label to use for the icon.  If empty, label is not displayed
        public let iconLabel: String

        /// The font to use for the icon label.
        public let iconLabelFont: NSFont

        /// The label for the 'select files' button.  If empty, no select files button is displayed
        public let selectFilesLabel: String

        /// If true, the select files button is displayed as a hyperlink style. If false, displays as a regular button.
        public let selectFilesButtonIsLink: Bool

        // MARK: - Callbacks

        /// Called when the user drags some files into the view.
        public let validateFiles: ValidateFuncType?

        /// Called when the user drops files on the view
        public let dropFiles: DropFuncType?

        /// Called when the user clicks the 'select files' button
        public let selectFiles: SelectFuncType?

        /// Initializer
        ///
        /// Needs to be provided as (by default) a default initializer is marked as internal
        public init(
            displayProperties: DisplayProperties = DisplayProperties(),
            isEnabled: Bool = true,
            allowsMultipleDrop: Bool = true,
            icon: NSImage? = nil,
            iconLabel: String = "",
            iconLabelFont: NSFont = .systemFont(ofSize: 16, weight: .bold),
            selectFilesLabel: String = "",
            selectFilesButtonIsLink: Bool = true,
            validateFiles: ValidateFuncType? = nil,
            dropFiles: DropFuncType? = nil,
            selectFiles: SelectFuncType? = nil
        ) {
            self.displayProperties = displayProperties
            self.isEnabled = isEnabled
            self.allowsMultipleDrop = allowsMultipleDrop
            self.icon = icon
            self.iconLabel = iconLabel
            self.iconLabelFont = iconLabelFont
            self.selectFilesLabel = selectFilesLabel
            self.selectFilesButtonIsLink = selectFilesButtonIsLink
            self.validateFiles = validateFiles
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
    if result != val {
        result = val
    }
}

extension DropFolderView.SwiftUI: NSViewRepresentable {
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeNSView(context: Context) -> DropFolderView {
        let view = DropFolderView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dropDelegate = context.coordinator
        return view
    }

    public func updateNSView(_ nsView: DropFolderView, context _: Context) {
        if self.icon !== nsView.icon {
            nsView.icon = self.icon
            nsView.showIcon = (nsView.icon != nil)
        }

        UpdateIfNotEqual(&nsView.isEnabled, self.isEnabled)
        UpdateIfNotEqual(&nsView.label, self.iconLabel)
        UpdateIfNotEqual(&nsView.selectFilesButtonLabel, self.selectFilesLabel)
        UpdateIfNotEqual(&nsView.allowsMultipleDrop, self.allowsMultipleDrop)
        UpdateIfNotEqual(&nsView.selectFilesButtonIsLink, self.selectFilesButtonIsLink)

        UpdateIfNotEqual(&nsView.isBordered, self.displayProperties.isBordered)
        UpdateIfNotEqual(&nsView.isAnimated, self.displayProperties.isAnimated)
        UpdateIfNotEqual(&nsView.lineWidth, self.displayProperties.lineWidth)
        UpdateIfNotEqual(&nsView.cornerRadius, self.displayProperties.cornerRadius)

        nsView.setLabelFont(self.iconLabelFont)
    }
}

// MARK: - Delegate handling

public extension DropFolderView.SwiftUI {
    class Coordinator: NSObject, DropFolderViewProtocol {
        let parent: DropFolderView.SwiftUI
        init(_ dropView: DropFolderView.SwiftUI) {
            self.parent = dropView
        }

        public func dropFilesView(_: DropFolderView, validateFiles: [URL]) -> NSDragOperation {
            return self.parent.validateFiles?(validateFiles) ?? []
        }

        public func dropFilesView(_: DropFolderView, didDropFiles files: [URL]) -> Bool {
            return self.parent.dropFiles?(files) ?? false
        }

        public func dropFilesViewWantsSelectFiles(_: DropFolderView) {
            self.parent.selectFiles?()
        }
    }
}
