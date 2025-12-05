//
//  BorderStyles.swift
//  colir
//
//  Created by Claude on 05.12.2024.
//  Copyright © 2024 IGR Soft. All rights reserved.
//

import SwiftUI

/// Standardized border styles for consistent selection and interaction states across the app.
///
/// Usage:
/// ```swift
/// RoundedRectangle(cornerRadius: 8)
///     .strokeBorder(BorderStyle.selected.color, lineWidth: BorderStyle.selected.width)
/// ```
enum BorderStyle {
    /// Default unselected border - subtle indication of cell boundaries
    case `default`
    /// Selected state - prominent accent color border
    case selected
    /// Keyboard focus state - system accent color
    case focus
    /// Error state - red border for validation errors
    case error

    /// The border width for this style
    var width: CGFloat {
        switch self {
        case .default:
            return 1.5
        case .selected:
            return 2.5
        case .focus:
            return 2.0
        case .error:
            return 1.5
        }
    }

    /// The border color for this style
    var color: Color {
        switch self {
        case .default:
            return Color.secondaryText.opacity(0.3)
        case .selected:
            return Color.selectedView
        case .focus:
            return Color.accentColor
        case .error:
            return Color(nsColor: .red500)
        }
    }
}

/// View modifier for applying standardized border styles
struct BorderStyleModifier: ViewModifier {
    let style: BorderStyle
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(style.color, lineWidth: style.width)
            )
    }
}

extension View {
    /// Applies a standardized border style to the view
    /// - Parameters:
    ///   - style: The border style to apply
    ///   - cornerRadius: The corner radius for the border (default: `.radiusSmall`)
    /// - Returns: A view with the border style applied
    func borderStyle(_ style: BorderStyle, cornerRadius: CGFloat = .radiusSmall) -> some View {
        modifier(BorderStyleModifier(style: style, cornerRadius: cornerRadius))
    }
}
