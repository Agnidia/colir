//
//  PrimaryProgressViewStyle.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A custom `ProgressViewStyle` that displays a progress bar with a gradient and customizable styling.
struct PrimaryProgressViewStyle: ProgressViewStyle {
    /// Colors used for the gradient of the progress bar.
    private static let hueColors = stride(from: 0, to: 1, by: 0.1).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }

    /// Gradient used for the progress bar fill.
    private var gradient = LinearGradient(
        gradient: Gradient(colors: hueColors),
        startPoint: .leading,
        endPoint: .trailing
    )

    /// The font style used for the progress label.
    var labelFontStyle: Font = .caption

    /// The corner radius of the progress bar.
    var cornerRadius: CGFloat = .radiusThin

    /// Creates and configures the body of the progress view.
    /// - Parameter configuration: The configuration for the progress view.
    /// - Returns: A view representing the progress bar with a gradient fill.
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? .zero

        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(.systemGray))
                .frame(height: geometry.size.height)
                .frame(width: geometry.size.width)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(gradient)
                        .mask(
                            Rectangle()
                                .frame(width: geometry.size.width * progress, height: geometry.size.height)
                                .padding(.trailing, geometry.size.width * (1 - progress))
                        )
                        .overlay {
                            if let currentValueLabel = configuration.currentValueLabel {
                                currentValueLabel
                                    .font(labelFontStyle)
                                    .foregroundColor(.white)
                            }
                        }
                }
        }
    }
}

extension ProgressViewStyle where Self == PrimaryProgressViewStyle {
    /// A static instance of `PrimaryProgressViewStyle` for use with `ProgressView`.
    ///
    /// This style applies a gradient to the progress bar and provides default settings
    /// for the progress view's appearance.
    ///
    /// To apply this style to a progress view, use the `progressViewStyle(_:)` modifier.
    ///
    /// Example:
    /// ```swift
    /// ProgressView(value: 0.5, total: 1.0)
    ///     .progressViewStyle(.primary)
    /// ```
    static var primary: PrimaryProgressViewStyle {
        .init()
    }
}

#Preview("PrimaryProgressViewStyle") {
    VStack {
        ProgressView("dd", value: 0, total: 100)
            .progressViewStyle(.primary)

        Divider()

        ProgressView("ss", value: 10, total: 100)
            .frame(height: 8)
            .progressViewStyle(.primary)

        Divider()

        ProgressView("", value: 20, total: 100)
            .progressViewStyle(.primary)

        Divider()

        ProgressView("", value: 30, total: 100)
            .progressViewStyle(.primary)

        Divider()

        ProgressView("", value: 40, total: 100)
            .progressViewStyle(.primary)

        Divider()

        ProgressView("", value: 50, total: 100)
            .progressViewStyle(.primary)

        Divider()

        ProgressView("", value: 60, total: 100)
            .progressViewStyle(.primary)

        Divider()

        ProgressView("", value: 70, total: 100)
            .progressViewStyle(.primary)

        Divider()

        ProgressView("", value: 80, total: 100)
            .progressViewStyle(.primary)

        Divider()

        ProgressView("", value: 90, total: 100)
            .progressViewStyle(.primary)

        Divider()

        ProgressView("", value: 1000, total: 100)
            .progressViewStyle(.primary)

        Divider()
    }
    .frame(width: 200)
    .padding(.paddingDefault)
}
