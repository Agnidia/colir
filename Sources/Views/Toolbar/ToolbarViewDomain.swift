//
//  ToolbarViewDomain.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

extension ToolbarView {
    enum ToolbarViewDomain {
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
            
            var title: LocalizedStringKey {
                LocalizedStringKey("toolbar.button." + rawValue)
            }
            
            var helpTitle: LocalizedStringKey {
                LocalizedStringKey("toolbar.button." + rawValue + ".help")
            }
            
            var icon: String {
                switch self {
                case .colors:
                    "paintpalette"
                case .photos:
                    "person.crop.rectangle"
                case .pictures:
                    "photo"
                case .emojis:
                    "face.smiling"
                case .decals:
                    "tag"
                case .spacer:
                    ""
                case .undo:
                    "arrow.counterclockwise.circle"
                case .redo:
                    "arrow.clockwise.circle"
                case .webResources:
                    "network"
                }
            }
            
            var tag: String {
                rawValue + "Tag"
            }
        }
    }
}
