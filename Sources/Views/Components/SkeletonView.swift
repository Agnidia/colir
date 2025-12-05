//
//  SkeletonView.swift
//  colir
//
//  Created by Claude on 05.12.2024.
//  Copyright © 2024 IGR Soft. All rights reserved.
//

import SwiftUI

/// A skeleton loading placeholder with shimmer animation.
///
/// Use this view to show loading states for content that hasn't loaded yet,
/// providing visual feedback that content is being fetched.
///
/// Usage:
/// ```swift
/// if isLoading {
///     SkeletonView()
///         .frame(width: 100, height: 100)
/// } else {
///     Image(nsImage: loadedImage)
/// }
/// ```
struct SkeletonView: View {

    /// The corner radius of the skeleton shape
    let cornerRadius: CGFloat

    /// Whether to show the shimmer animation
    let animated: Bool

    @State private var shimmerOffset: CGFloat = -1.0

    init(cornerRadius: CGFloat = .radiusSmall, animated: Bool = true) {
        self.cornerRadius = cornerRadius
        self.animated = animated
    }

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.secondaryBackground)
                .overlay(
                    shimmerOverlay(width: geometry.size.width)
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .onAppear {
            if animated {
                startShimmerAnimation()
            }
        }
    }

    @ViewBuilder
    private func shimmerOverlay(width: CGFloat) -> some View {
        if animated {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.primaryText.opacity(0.1),
                    Color.clear
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: width * 0.5)
            .offset(x: shimmerOffset * width)
            .animation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false),
                value: shimmerOffset
            )
        }
    }

    private func startShimmerAnimation() {
        shimmerOffset = -1.0
        withAnimation {
            shimmerOffset = 2.0
        }
    }
}

/// A skeleton view specifically designed for image placeholders
struct ImageSkeletonView: View {

    let cornerRadius: CGFloat

    init(cornerRadius: CGFloat = .radiusSmall) {
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        SkeletonView(cornerRadius: cornerRadius)
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.secondaryText.opacity(0.5))
            )
    }
}

// MARK: - Preview

#Preview("SkeletonView") {
    VStack(spacing: 20) {
        SkeletonView()
            .frame(width: 128, height: 128)

        ImageSkeletonView()
            .frame(width: 128, height: 128)

        HStack(spacing: 10) {
            SkeletonView()
                .frame(width: 80, height: 80)
            SkeletonView()
                .frame(width: 80, height: 80)
            SkeletonView()
                .frame(width: 80, height: 80)
        }
    }
    .padding()
}
