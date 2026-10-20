//
//  ToolbarViewDomain.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import SwiftUI

extension ToolbarView {
    /// Contains definitions and utility methods for toolbar actions.
    enum ToolbarViewDomain {
        /// Defines the available actions in the toolbar.
        enum Action: String, Equatable {
            case undo
            case redo
            case colors
            case photos
            case pictures
            case emojis
            case decals
            case webResources
            case spacer
            case tips

            /// A localized title for the toolbar button associated with the action.
            var title: LocalizedStringKey {
                LocalizedStringKey("toolbar.button." + rawValue)
            }

            /// A localized help title for the toolbar button associated with the action.
            var helpTitle: LocalizedStringKey {
                LocalizedStringKey("toolbar.button." + rawValue + ".help")
            }

            /// The system icon name associated with the action.
            var icon: String {
                switch self {
                case .colors: "paintpalette"
                case .photos: "person.crop.rectangle"
                case .pictures: "photo"
                case .emojis: "face.smiling"
                case .decals: "tag"
                case .spacer: ""
                case .undo: "arrow.counterclockwise.circle"
                case .redo: "arrow.clockwise.circle"
                case .webResources: "network"
                case .tips: "bag"
                }
            }

            /// A unique tag identifier for the toolbar action.
            var tag: String {
                rawValue + "Tag"
            }
        }
    }
}
