//
//  ToolsEmojisView.swift
//
//  Created on 10.10.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import SwiftCommons
import SwiftUI

/// A view that displays a list of emoji groups with expandable sections.
/// Each group of emojis is shown in a `DisclosureGroup`, and individual emojis can be selected.
///
/// This view uses `ToolsEmojisViewModel` as its environment object to manage state, such as which groups are expanded and which emoji is selected.
struct ToolsEmojisView: View {
    /// The view model responsible for managing the state and settings of the emoji view.
    @EnvironmentObject var viewModel: ToolsEmojisViewModel

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ForEach(viewModel.groups, id: \.self) { group in
                    // Check if there are emojis to display for the current group
                    if let emojis = viewModel.emojis[group], emojis.isEmpty == false {
                        let isExpanded = viewModel.expanded.contains(group)
                        DisclosureGroup(
                            isExpanded: Binding<Bool>(
                                get: { viewModel.expanded.contains(group) },
                                set: { isExpanding in
                                    if isExpanding {
                                        viewModel.expanded.insert(group)
                                    } else {
                                        viewModel.expanded.remove(group)
                                    }
                                }
                            )
                        ) {
                            emojiesList(geometry: geometry, emojis: emojis)
                        } label: {
                            Text(group.name)
                                .font(.title2)
                                .onTapGesture {
                                    // Toggle the expansion state of the group
                                    if viewModel.expanded.contains(group) {
                                        viewModel.expanded.remove(group)
                                    } else {
                                        viewModel.expanded.insert(group)
                                    }
                                }
                        }
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("\(group.name), \(emojis.count) emojis, \(isExpanded ? "expanded" : "collapsed")")
                        .accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand")
                    }
                }
                .padding(.paddingDefault)
            }
        }
    }

    @ViewBuilder
    private func emojiesList(geometry: GeometryProxy, emojis: [Character]) -> some View {
        // Display emojis in a grid within the DisclosureGroup
        LazyVGrid(columns: viewModel.columns(in: geometry), alignment: .leading, spacing: viewModel.viewSettings.spacing) {
            ForEach(emojis, id: \.self) { char in
                emojiCell(for: char)
            }
        }
        .padding(.paddingThin)
    }

    @ViewBuilder
    private func emojiCell(for char: Character) -> some View {
        SelectableGridCell(
            isSelected: viewModel.selectedEmoji == char,
            cornerRadius: viewModel.cellCornerRadius,
            accessibilityLabel: emojiAccessibilityLabel(for: char),
            accessibilityHint: "tap to add this emoji to the folder"
        ) {
            Text(String(char))
                .font(.system(size: viewModel.fontSize))
                .frame(maxWidth: .infinity, minHeight: viewModel.columnWidth, maxHeight: viewModel.columnWidth, alignment: .center)
                .padding(.paddingDefault)
                .background(Color.secondaryBackground)
                .foregroundColor(.white)
        } onTap: {
            if viewModel.selectedEmoji == char {
                viewModel.selectedEmoji = nil
            } else {
                viewModel.selectedEmoji = char
            }
        }
    }

    /// Gets the accessibility label for an emoji character
    private func emojiAccessibilityLabel(for char: Character) -> String {
        // Get Unicode name for the emoji if available
        if let scalar = char.unicodeScalars.first {
            if let name = scalar.properties.name {
                return name.capitalized
            }
        }
        return "Emoji \(char)"
    }
}

#Preview("ToolsEmojisView") {
    ToolsEmojisView()
        .environmentObject(ToolsEmojisViewModel.preview)
}
