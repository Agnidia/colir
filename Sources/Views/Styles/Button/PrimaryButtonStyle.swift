//
//  PrimaryButtonStyle.swift
//  VideoScripterRecorder
//
//  Created by Vitalii Parovishnyk 23.10.2023.
//  Copyright © 2023 VideoScripter Kft. All rights reserved.
//

import SwiftUI

struct PrimaryButtonStyle: PrimitiveButtonStyle {
        
    private struct PrimaryButtonStyleView<V: View>: View {
        @Environment(\.isEnabled) private var isEnabled: Bool
                
        @State private var isOverButton = false
        
        var cornerRadius: CGFloat = 8

        let content: () -> V

        var body: some View {
            ZStack(alignment: .center) {
                content()
                    .buttonStyle(.borderless)
                    .foregroundColor(isEnabled ? Color.primaryTitleButton : Color.primaryDisabledTitleButton)
            }
            .background(content: {
                if isEnabled == false {
                    Rectangle()
                    .fill(Color.primaryDisabledBackgroundButton)
                    .cornerRadius(cornerRadius)
                } else {
                    Rectangle()
                    .fill(isOverButton ? Color.primaryHoveredButton : Color.primaryBackgroundButton)
                    .cornerRadius(cornerRadius)
                }
            })
            .onHover { over in
                self.isOverButton = over
            }
        }
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        PrimaryButtonStyleView() {
            configuration.label
        }
    }
}

extension PrimitiveButtonStyle where Self == PrimaryButtonStyle {

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
