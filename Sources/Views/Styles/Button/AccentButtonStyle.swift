//
//  AccentButtonStyle.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct AccentButtonStyle: ButtonStyle {
    
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
    
    func makeBody(configuration: Self.Configuration) -> some View {
        StyleView() {
            configuration.label
        }
    }
}

extension ButtonStyle where Self == AccentButtonStyle {
    
    /// A button style that doesn't apply a border.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View().buttonStyle(.accent)`` modifier.
    static var accent: AccentButtonStyle {
        .init()
    }
}
