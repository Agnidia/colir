//
//  SelectableGridCell.swift
//  colir
//
//  Created by Claude on 05.12.2024.
//  Copyright © 2024 IGR Soft. All rights reserved.
//

import SwiftUI

/// A reusable grid cell component with standardized selection and hover states.
///
/// This component provides consistent selection behavior across all tool grids
/// (colors, photos, emojis) including:
/// - Standardized border widths (1.5px default, 2.5px selected)
/// - Checkmark badge in top-right corner
/// - Hover state with subtle scale and elevation
/// - Spring animation on selection
///
/// Usage:
/// ```swift
/// SelectableGridCell(
///     isSelected: selectedColor == color,
///     cornerRadius: .radiusSmall
/// ) {
///     // Cell content
///     RoundedRectangle(cornerRadius: .radiusSmall)
///         .fill(Color(nsColor: color))
/// } onTap: {
///     selectedColor = color
/// }
/// ```
struct SelectableGridCell<Content: View>: View {

    let isSelected: Bool
    let cornerRadius: CGFloat
    let content: Content
    let onTap: () -> Void

    /// Accessibility label for VoiceOver
    let accessibilityLabel: String?

    /// Accessibility hint for VoiceOver
    let accessibilityHint: String?

    @State private var isHovered = false
    @FocusState private var isFocused: Bool

    init(
        isSelected: Bool,
        cornerRadius: CGFloat = .radiusSmall,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        @ViewBuilder content: () -> Content,
        onTap: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.content = content()
        self.onTap = onTap
    }

    var body: some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(selectionOverlay)
            .overlay(hoveredOverlay)
            .scaleEffect(scaleEffect)
            .elevation(isHovered ? .level2 : .level0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
            .animation(.easeInOut(duration: 0.15), value: isFocused)
            .onHover { hovering in
                isHovered = hovering
            }
            .onTapGesture {
                onTap()
            }
            .onLongPressGesture {
                onTap()
            }
            // Accessibility
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabelText)
            .accessibilityHint(accessibilityHintText)
            .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : [.isButton])
            // Keyboard focus
            .focusable()
            .focused($isFocused)
            .focusEffectDisabled()
            .onKeyPress(.space) {
                onTap()
                return .handled
            }
            .onKeyPress(.return) {
                onTap()
                return .handled
            }
            .contentShape(Rectangle())
    }

    // MARK: - Computed Properties

    private var accessibilityLabelText: String {
        if let label = accessibilityLabel {
            return isSelected ? "\(label), selected" : label
        }
        return isSelected ? "Selected item" : "Item"
    }

    private var accessibilityHintText: String {
        accessibilityHint ?? (isSelected ? "Double tap to deselect" : "Double tap to select")
    }

    private var scaleEffect: CGFloat {
        if isHovered && !isSelected {
            return 1.02
        }
        return 1.0
    }

    @ViewBuilder
    private var selectionOverlay: some View {
        ZStack(alignment: .topTrailing) {
            // Border
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(
                    isSelected ? BorderStyle.selected.color : BorderStyle.default.color,
                    lineWidth: isSelected ? BorderStyle.selected.width : BorderStyle.default.width
                )

            // Checkmark badge
            checkmarkBadge
        }
    }

    @ViewBuilder
    private var checkmarkBadge: some View {
        Image(systemName: "checkmark.circle.fill")
            .symbolRenderingMode(.palette)
            .foregroundStyle(Color.primaryText, Color.selectedView)
            .font(.system(size: 18, weight: .medium))
            .padding(.paddingThin)
            .scaleEffect(isSelected ? 1.0 : 0.5)
            .opacity(isSelected ? 1.0 : 0.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }

    /// Focus ring overlay for keyboard navigation
    @ViewBuilder
    private var hoveredOverlay: some View {
        if isHovered {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(BorderStyle.default.color, lineWidth: BorderStyle.default.width)
        }
    }
}

// MARK: - Preview

#Preview("SelectableGridCell") {
    HStack(spacing: 16) {
        SelectableGridCell(
            isSelected: false,
            cornerRadius: .radiusSmall
        ) {
            RoundedRectangle(cornerRadius: .radiusSmall)
                .fill(Color.blue)
                .frame(width: 80, height: 80)
        } onTap: {}

        SelectableGridCell(
            isSelected: true,
            cornerRadius: .radiusSmall
        ) {
            RoundedRectangle(cornerRadius: .radiusSmall)
                .fill(Color.green)
                .frame(width: 80, height: 80)
        } onTap: {}
    }
    .padding()
}
