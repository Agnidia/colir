//
//  View+Accessibility.swift
//  colir
//
//  Created by Claude on 15.12.2024.
//  Copyright © 2024 IGR Soft. All rights reserved.
//

import SwiftUI

/// Reusable accessibility modifiers for consistent VoiceOver and keyboard support.
///
/// These extensions provide standardized accessibility patterns that match
/// the implementation in `SelectableGridCell` and ensure WCAG 2.1 compliance.
extension View {
    // MARK: - Button Accessibility

    /// Apply standard button accessibility with label and hint.
    ///
    /// Use this for any interactive button-like element that performs an action.
    ///
    /// - Parameters:
    ///   - label: The accessibility label describing what the button is
    ///   - hint: Optional hint describing what happens when activated (defaults to "Double tap to activate")
    ///   - isSelected: Whether the button is in a selected state
    /// - Returns: View with accessibility modifiers applied
    func accessibleButton(
        label: String,
        hint: String? = nil,
        isSelected: Bool = false
    ) -> some View {
        accessibilityElement(children: .ignore)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "Double tap to activate")
            .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }

    /// Apply accessibility for image-only buttons.
    ///
    /// Use this for buttons that only contain an SF Symbol or image.
    ///
    /// - Parameters:
    ///   - label: The accessibility label describing the button action
    ///   - hint: Optional hint describing the result of the action
    /// - Returns: View with accessibility label and hint
    func accessibleImageButton(
        label: String,
        hint: String? = nil
    ) -> some View {
        accessibilityLabel(label)
            .accessibilityHint(hint ?? "Double tap to activate")
    }

    // MARK: - Toggle/Disclosure Accessibility

    /// Apply accessibility for toggle/disclosure controls.
    ///
    /// Use this for expandable sections, disclosure groups, and toggles.
    ///
    /// - Parameters:
    ///   - label: The name of the expandable section
    ///   - isExpanded: Current expansion state
    ///   - itemCount: Optional number of items in the section
    /// - Returns: View with toggle accessibility modifiers
    func accessibleToggle(
        label: String,
        isExpanded: Bool,
        itemCount: Int? = nil
    ) -> some View {
        let stateText = isExpanded ? "expanded" : "collapsed"
        let countText = itemCount.map { ", \($0) items" } ?? ""

        return accessibilityElement(children: .ignore)
            .accessibilityLabel("\(label)\(countText), \(stateText)")
            .accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand")
            .accessibilityAddTraits([.isButton])
    }

    // MARK: - Container Accessibility

    /// Apply accessibility for grid or list containers.
    ///
    /// Use this for ScrollViews, LazyVGrids, or Lists that contain multiple items.
    ///
    /// - Parameters:
    ///   - label: Description of the container contents
    ///   - itemCount: Number of items in the container
    /// - Returns: View with container accessibility
    func accessibleContainer(
        label: String,
        itemCount: Int
    ) -> some View {
        accessibilityElement(children: .contain)
            .accessibilityLabel("\(label), \(itemCount) items")
    }

    // MARK: - Interactive Zone Accessibility

    /// Apply accessibility for drop zones and interactive areas.
    ///
    /// Use this for drag-and-drop targets and click-to-select zones.
    ///
    /// - Parameters:
    ///   - label: Description of the zone
    ///   - hint: Interaction instructions
    ///   - hasContent: Whether the zone currently has content
    ///   - contentDescription: Description of current content (if any)
    /// - Returns: View with interactive zone accessibility
    func accessibleZone(
        label: String,
        hint: String,
        hasContent: Bool,
        contentDescription: String? = nil
    ) -> some View {
        let value = hasContent ? (contentDescription ?? "Content selected") : "Empty"

        return accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint)
            .accessibilityValue(value)
            .accessibilityAddTraits([.isButton])
    }

    // MARK: - Removable Item Accessibility

    /// Apply accessibility for items that can be removed (like style tags).
    ///
    /// - Parameters:
    ///   - label: Description of the item
    ///   - removeHint: Hint for removal action
    /// - Returns: View with removable item accessibility and keyboard support
    func accessibleRemovableItem(
        label: String,
        removeHint: String = "Press Delete to remove"
    ) -> some View {
        accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(removeHint)
    }
}
