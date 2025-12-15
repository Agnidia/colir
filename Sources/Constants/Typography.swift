//
//  Typography.swift
//  colir
//
//  Created by Claude on 05.12.2024.
//  Copyright © 2024 IGR Soft. All rights reserved.
//

import SwiftUI

/// Standardized typography scale for consistent text hierarchy across the app.
///
/// Usage:
/// ```swift
/// Text("Category Header")
///     .font(Typography.headlineMedium)
/// ```
enum Typography {
    /// Large display text - empty state titles, hero text
    static let displayLarge: Font = .system(size: 28, weight: .regular)

    /// Medium display text - section headers
    static let displayMedium: Font = .system(size: 24, weight: .regular)

    /// Large headline - panel titles
    static let headlineLarge: Font = .system(size: 20, weight: .semibold)

    /// Medium headline - category headers, group titles
    static let headlineMedium: Font = .system(size: 17, weight: .semibold)

    /// Small headline - subheaders
    static let headlineSmall: Font = .system(size: 15, weight: .semibold)

    /// Large body text - primary content
    static let bodyLarge: Font = .system(size: 15, weight: .regular)

    /// Medium body text - secondary content
    static let bodyMedium: Font = .system(size: 13, weight: .regular)

    /// Small body text - tertiary content
    static let bodySmall: Font = .system(size: 11, weight: .regular)

    /// Large label - buttons, emphasized labels
    static let labelLarge: Font = .system(size: 13, weight: .medium)

    /// Medium label - tags, badges
    static let labelMedium: Font = .system(size: 11, weight: .medium)

    /// Small label - captions, helper text
    static let labelSmall: Font = .system(size: 10, weight: .regular)
}

// MARK: - View Extension for Typography

extension View {
    /// Applies a typography style to the view
    /// - Parameter style: The typography font to apply
    /// - Returns: A view with the typography style applied
    func typography(_ style: Font) -> some View {
        font(style)
    }
}
