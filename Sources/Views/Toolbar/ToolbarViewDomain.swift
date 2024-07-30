//
//  ToolbarViewDomain.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
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
                case .colors: return "paintpalette"
                case .photos: return "person.crop.rectangle"
                case .pictures: return "photo"
                case .emojis: return "face.smiling"
                case .decals: return "tag"
                case .spacer: return ""
                case .undo: return "arrow.counterclockwise.circle"
                case .redo: return "arrow.clockwise.circle"
                case .webResources: return "network"
                }
            }
            
            /// A unique tag identifier for the toolbar action.
            var tag: String {
                rawValue + "Tag"
            }
        }
    }
}
