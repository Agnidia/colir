//
//  ToolsColorsView.swift
//
//  Created on 07.10.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import Algorithms
import SwiftUI

/// A view that displays a list of color options for selection.
///
/// `ToolsColorsView` uses a view model to provide color options and a title for the color picker.
/// It presents a scrollable list of colors that the user can select from.
///
/// - Environment:
///   - `viewModel`: An instance of `ToolsColorsViewModel` that provides data and behavior for the view.
///
/// - Views:
///   - `colorPickerTitle`: A view displaying the title for the color picker.
///   - `colorsList`: A view displaying a list of color options for the user to choose from.
struct ToolsColorsView: View {
    @Environment(ToolsColorsViewModel.self) var viewModel

    @State private var selectedColor: NSColor? = nil

    /// Tracks which color groups are expanded to show all shades
    @State private var expandedGroups: Set<String> = []

    @Namespace private var namespace

    /// Color groups ordered by hue wheel
    private let colorGroups: [NSColor.ColorGroup] = NSColor.colorGroupsOrdered

    var body: some View {
        ScrollView {
            colorPickerTitle

            recentColorsSection

            colorsList
        }
        .animation(.default, value: viewModel.recentColors)
        .onChange(of: selectedColor) { _, newValue in
            viewModel.selectedColor = newValue
            viewModel.selectedColorPublisher.send(newValue)
        }
        .onChange(of: viewModel.selectedColor) { _, newValue in
            selectedColor = newValue
        }
    }

    /// Section showing recently used colors
    @ViewBuilder
    private var recentColorsSection: some View {
        VStack(alignment: .leading, spacing: .spacingDefault) {
            HStack {
                Text("Recent")
                    .font(Typography.headlineMedium)
                    .foregroundStyle(Color.primaryText)

                Spacer()

                Button {
                    viewModel.clearRecentColors()
                } label: {
                    Text("Clear")
                        .font(Typography.labelMedium)
                        .foregroundStyle(Color.secondaryText)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, .paddingDefault)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .spacingDefault) {
                    ForEach(viewModel.recentColors, id: \.self) { color in
                        cell(for: color)
                    }
                }
                .padding(.horizontal, .paddingDefault)
            }

            Divider()
                .padding(.horizontal, .paddingDefault)
                .padding(.top, .paddingSmall)
        }
        .isHidden(viewModel.recentColors.isEmpty)
        .animation(.default, value: viewModel.recentColors)
    }

    var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: ToolsColorsViewModel.cellWidth)),
        ]
    }

    @ViewBuilder
    var colorPickerTitle: some View {
        VStack(spacing: viewModel.viewSettings.spacing) {
            customColorButton

            Divider()
        }
        .padding(.horizontal, .paddingDefault)
        .padding(.vertical, viewModel.viewSettings.padding.top)
    }

    /// Custom color picker button with improved discoverability
    @ViewBuilder
    private var customColorButton: some View {
        HStack(spacing: .spacingDefault) {
            // Color swatch showing current custom color or + icon
            ZStack {
                RoundedRectangle(cornerRadius: .radiusSmall)
                    .fill(selectedColor != nil ? Color(nsColor: selectedColor!) : Color.secondaryBackground)
                    .frame(width: 48, height: 36)
                    .overlay(
                        RoundedRectangle(cornerRadius: .radiusSmall)
                            .strokeBorder(Color.primaryText.opacity(0.2), lineWidth: 1)
                    )

                if selectedColor == nil {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.secondaryText)
                }
            }

            Text(ToolsColorsViewDomain.Localization.customColor)
                .font(Typography.headlineSmall)
                .foregroundStyle(Color.primaryText)

            Spacer()

            // Native color picker (hidden, triggered by button)
            ColorPicker(
                selection: Binding(
                    get: { Color(nsColor: selectedColor ?? .systemGray) },
                    set: { selectedColor = NSColor($0) }
                ),
                supportsOpacity: false
            ) {}
                .labelsHidden()
                .frame(width: 28, height: 28)
                .padding(.trailing, 10)
        }
        .padding(.paddingSmall)
        .background(Color.secondaryBackground.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: .radiusSmall))
    }

    @ViewBuilder
    var colorsList: some View {
        LazyVStack(spacing: .spacingHeight) {
            ForEach(colorGroups) { group in
                colorGroupSection(for: group)
            }
        }
        .padding(EdgeInsets(top: .zero, leading: .paddingDefault, bottom: .paddingDefault, trailing: .paddingDefault))
    }

    /// A collapsible color group section
    /// Shows only the 500 shade by default, expands to show all shades when tapped
    @ViewBuilder
    private func colorGroupSection(for group: NSColor.ColorGroup) -> some View {
        let isExpanded = expandedGroups.contains(group.id)

        VStack(alignment: .leading, spacing: .spacingDefault) {
            // Header with expand/collapse toggle
            colorGroupHeader(for: group, isExpanded: isExpanded)

            // Color grid - shows primary color only or all shades
            if isExpanded {
                LazyVGrid(columns: columns, spacing: viewModel.viewSettings.spacing) {
                    // Show all shades when expanded
                    ForEach(group.colors, id: \.self) { color in
                        cell(for: color)
                            .matchedGeometryEffect(id: color.hexString, in: namespace)
                    }
                }
            } else {
                // Show only the 500 shade (primary) when collapsed
                cell(for: group.primaryColor, width: .infinity)
                    .padding(.horizontal, .paddingCompact)
                    .frame(maxWidth: .infinity)
                    .matchedGeometryEffect(id: group.primaryColor.hexString, in: namespace)
            }
        }
        .clipped()
    }

    /// Header for a color group with expand/collapse functionality
    @ViewBuilder
    private func colorGroupHeader(for group: NSColor.ColorGroup, isExpanded: Bool) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                if isExpanded {
                    expandedGroups.remove(group.id)
                } else {
                    expandedGroups.insert(group.id)
                }
            }
        } label: {
            HStack(spacing: .spacingDefault) {
                // Color indicator
                Circle()
                    .fill(Color(nsColor: group.primaryColor))
                    .frame(width: 12, height: 12)

                Text(group.name)
                    .font(Typography.headlineMedium)
                    .foregroundStyle(Color.primaryText)

                Spacer()

                // Shade count badge
                Text(isExpanded ? "\(group.colors.count) shades" : "Tap to expand")
                    .font(Typography.labelMedium)
                    .foregroundStyle(Color.primaryText)

                // Chevron indicator
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.primaryText)
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .padding(.vertical, .paddingSmall)
            .padding(.horizontal, .paddingSmall)
            .background(Color.secondaryBackground.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: .radiusSmall))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(group.name), \(group.colors.count) shades, \(isExpanded ? "expanded" : "collapsed")")
        .accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand")
        .accessibilityAddTraits([.isButton])
    }

    @ViewBuilder
    private func cell(for color: NSColor, width: CGFloat = ToolsColorsViewModel.cellWidth) -> some View {
        SelectableGridCell(
            isSelected: selectedColor == color,
            cornerRadius: viewModel.cellCornerRadius,
            accessibilityLabel: "Color \(color.hexString)",
            accessibilityHint: "Tap to apply this color to the folder"
        ) {
            if width == .infinity {
                RoundedRectangle(cornerRadius: viewModel.cellCornerRadius, style: .continuous)
                    .fill(Color(nsColor: color))
                    .frame(maxWidth: width, minHeight: ToolsColorsViewModel.cellHeight, maxHeight: ToolsColorsViewModel.cellHeight)
            } else {
                RoundedRectangle(cornerRadius: viewModel.cellCornerRadius, style: .continuous)
                    .fill(Color(nsColor: color))
                    .frame(width: width, height: ToolsColorsViewModel.cellHeight)
            }
        } onTap: {
            if selectedColor == color {
                selectedColor = nil
            } else {
                selectedColor = color
            }
        }
    }
}

#Preview("ToolsColorsView") {
    ToolsColorsView()
        .environment(ToolsColorsViewModel.preview)
}
