//
//  AppStoreButtonStyle.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 16.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A custom `ButtonStyle` that applies an App Store-themed color scheme and hover effects to buttons.
struct AppStoreButtonStyle: ButtonStyle {
    
    /// A private view that applies the App Store button style, handling hover and enabled/disabled states.
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
                    Rectangle()
                        .fill(ButtonStyleConstants.backgroundDisabledColor)
                        .cornerRadius(cornerRadius)
                } else {
                    Rectangle()
                        .fill(isHovered ? ButtonStyleConstants.backgroundAppStoreHoveredColor : ButtonStyleConstants.backgroundAppStoreColor)
                        .cornerRadius(cornerRadius)
                }
            })
            .onHover { over in
                self.isHovered = over
            }
        }
    }
    
    /// Creates a view that displays the button with the App Store style.
    /// - Parameter configuration: The configuration for the button.
    /// - Returns: A view that applies the App Store button style.
    func makeBody(configuration: Self.Configuration) -> some View {
        StyleView() {
            configuration.label
        }
    }
}

extension ButtonStyle where Self == AppStoreButtonStyle {
    
    /// A static instance of `AppStoreButtonStyle` for use with `Button`.
    ///
    /// This style applies an App Store-themed color scheme to the button with hover and disabled state effects.
    ///
    /// To apply this style to a button, use the `buttonStyle(_:)` modifier.
    ///
    /// Example:
    /// ```swift
    /// Button("Click Me") {
    ///     // Button action
    /// }
    /// .buttonStyle(.appStore)
    /// ```
    static var appStore: AppStoreButtonStyle {
        .init()
    }
}

#Preview("AppStoreButtonStyle") {
    HStack {
        Button(action: {}, label: {
            Text("test")
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
        })
        .buttonStyle(.appStore)
        .padding(.paddingDefault)
        .disabled(false)
        
        Button(action: {}, label: {
            Text("test")
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
        })
        .buttonStyle(.appStore)
        .padding(.paddingDefault)
        .disabled(true)
    }
}
