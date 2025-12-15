//
//  AccentButtonStyle.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A custom `ButtonStyle` that applies accent colors and hover effects to buttons.
struct AccentButtonStyle: ButtonStyle {
    /// A view that applies the button style with hover and enabled/disabled states.
    private struct StyleView<V: View>: View {
        @Environment(\.isEnabled) private var isEnabled: Bool

        @State private var isHovered = false

        var cornerRadius: CGFloat = ButtonStyleConstants.cornerRadius

        let content: () -> V

        var body: some View {
            ZStack(alignment: .center) {
                content()
                    .foregroundColor(isEnabled ? ButtonStyleConstants.textColor : ButtonStyleConstants.textDisableColor)
            }
            .background(content: {
                if isEnabled == false {
                    Rectangle()
                        .fill(ButtonStyleConstants.backgroundDisabledColor)
                        .cornerRadius(cornerRadius)
                } else {
                    Rectangle()
                        .fill(isHovered ? ButtonStyleConstants.backgroundAccentHoveredColor : ButtonStyleConstants.backgroundAccentColor)
                        .cornerRadius(cornerRadius)
                }
            })
            .onHover { over in
                self.isHovered = over
            }
        }
    }

    /// Creates a view that displays the button with the accent style.
    /// - Parameter configuration: The configuration for the button.
    /// - Returns: A view that applies the accent button style.
    func makeBody(configuration: Self.Configuration) -> some View {
        StyleView {
            configuration.label
        }
    }
}

extension ButtonStyle where Self == AccentButtonStyle {
    /// A static instance of `AccentButtonStyle` for use with `Button`.
    ///
    /// This style applies an accent color to the button with hover and disabled state effects.
    ///
    /// To apply this style to a button, use the `buttonStyle(_:)` modifier.
    ///
    /// Example:
    /// ```swift
    /// Button("Click Me") {
    ///     // Button action
    /// }
    /// .buttonStyle(.accent)
    /// ```
    static var accent: AccentButtonStyle {
        .init()
    }
}
