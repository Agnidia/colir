//
//  ElevationModifier.swift
//
//  Created on 05.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import SwiftUI

/// Standardized elevation levels for consistent shadow hierarchy across the app.
///
/// Usage:
/// ```swift
/// RoundedRectangle(cornerRadius: 8)
///     .elevation(.level2)
/// ```
enum Elevation {
    /// No elevation - flat elements
    case level0
    /// Subtle elevation - cards, grid cells at rest
    case level1
    /// Medium elevation - hover states, raised cards
    case level2
    /// High elevation - dropdowns, popovers
    case level3
    /// Highest elevation - modals, dialogs
    case level4

    var shadowColor: Color {
        Color.black.opacity(shadowOpacity)
    }

    private var shadowOpacity: Double {
        switch self {
        case .level0: 0
        case .level1: 0.08
        case .level2: 0.12
        case .level3: 0.16
        case .level4: 0.24
        }
    }

    var radius: CGFloat {
        switch self {
        case .level0: 0
        case .level1: 2
        case .level2: 4
        case .level3: 8
        case .level4: 16
        }
    }

    var y: CGFloat {
        switch self {
        case .level0: 0
        case .level1: 1
        case .level2: 2
        case .level3: 4
        case .level4: 8
        }
    }
}

/// View modifier for applying standardized elevation shadows
struct ElevationModifier: ViewModifier {
    let level: Elevation

    func body(content: Content) -> some View {
        content
            .shadow(color: level.shadowColor, radius: level.radius, x: 0, y: level.y)
    }
}

extension View {
    /// Applies a standardized elevation shadow to the view
    /// - Parameter level: The elevation level to apply
    /// - Returns: A view with the elevation shadow applied
    func elevation(_ level: Elevation) -> some View {
        modifier(ElevationModifier(level: level))
    }
}
