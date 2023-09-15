//
//  ToolbarViewDomain.swift
//  colir
//
//  Created by Vitalii P on 23.07.2023.
//

import SwiftUI

extension ToolbarView {
    enum ToolbarViewDomain {
        enum Action: String, Equatable {
            case undo
            case redo
            case colors
            case photos
            case emojies
            case decals
            
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
                    return "paintpalette"
                case .photos:
                    return "photo"
                case .emojies:
                    return "face.smiling"
                case .decals:
                    return "tag"
                case .spacer:
                    return ""
                case .undo:
                    return "arrow.counterclockwise.circle"
                case .redo:
                    return "arrow.clockwise.circle"
                }
            }
            
            var tag: String {
                rawValue + "Tag"
            }
        }
    }
}
