//
//  AppStoreButtonStyle.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 16.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct AppStoreButtonStyle: ButtonStyle {
    
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
                        .fill(isHovered ? ButtonStyleConstants.backgroundAppStoreHoveredColor : ButtonStyleConstants.backgroundAppStoreColor)
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

extension ButtonStyle where Self == AppStoreButtonStyle {
    
    /// A button style that doesn't apply a border.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View().buttonStyle(.primary)`` modifier.
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
        .padding()
        .disabled(false)
        
        Button(action: {}, label: {
            Text("test")
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
        })
        .buttonStyle(.appStore)
        .padding()
        .disabled(true)
    }
}
