//
//  PrimaryButtonStyle.swift
//  colir
//
//  Created by Vitalii Parovishnyk 23.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A custom `ButtonStyle` that applies a primary color scheme and hover effects to buttons.
struct PrimaryButtonStyle: ButtonStyle {
    
    /// A private view that applies the button style, handling hover and enabled/disabled states.
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
                if !isEnabled {
                    UnevenRoundedRectangle(cornerRadii: .init(topTrailing: cornerRadius))
                                        .fill(ButtonStyleConstants.backgroundDisabledColor)
                } else {
                    UnevenRoundedRectangle(cornerRadii: .init(topTrailing: cornerRadius))
                        .fill(isHovered ? ButtonStyleConstants.backgroundHoveredColor : ButtonStyleConstants.backgroundColor)
                }
            })
            .onHover { over in
                self.isHovered = over
            }
        }
    }
    
    /// Creates a view that displays the button with the primary style.
    /// - Parameter configuration: The configuration for the button.
    /// - Returns: A view that applies the primary button style.
    func makeBody(configuration: Self.Configuration) -> some View {
        StyleView() {
            configuration.label
        }
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    
    /// A static instance of `PrimaryButtonStyle` for use with `Button`.
    ///
    /// This style applies a primary color scheme to the button with hover and disabled state effects.
    ///
    /// To apply this style to a button, use the `buttonStyle(_:)` modifier.
    ///
    /// Example:
    /// ```swift
    /// Button("Click Me") {
    ///     // Button action
    /// }
    /// .buttonStyle(.primary)
    /// ```
    static var primary: PrimaryButtonStyle {
        .init()
    }
}

#Preview("PrimaryButtonStyle") {
    HStack {
        Button(action: {}, label: {
            Text("test")
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
        })
        .buttonStyle(.primary)
        .padding(.paddingDefault)
        .disabled(false)
        
        Button(action: {}, label: {
            Text("test")
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
        })
        .buttonStyle(.primary)
        .padding(.paddingDefault)
        .disabled(true)
    }
}
