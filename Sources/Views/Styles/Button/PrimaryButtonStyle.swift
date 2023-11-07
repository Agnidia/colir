//
//  PrimaryButtonStyle.swift
//  VideoScripterRecorder
//
//  Created by Vitalii Parovishnyk 23.10.2023.
//  Copyright © 2023 VideoScripter Kft. All rights reserved.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
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
                        .fill(isHovered ? ButtonStyleConstants.backgroundHovered : ButtonStyleConstants.backgroundColor)
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

extension ButtonStyle where Self == PrimaryButtonStyle {
    
    /// A button style that doesn't apply a border.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View/buttonStyle(_:)-66fbx`` modifier.
    ///
    /// On tvOS, this button style adds a default hover effect to the first
    /// image of the button's content, if one exists. You can supply a different
    /// hover effect by using the ``View/hoverEffect(_:)`` modifier in the
    /// button's label.
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
        .padding()
        .disabled(false)
        
        Button(action: {}, label: {
            Text("test")
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
        })
        .buttonStyle(.primary)
        .padding()
        .disabled(true)
    }
}
