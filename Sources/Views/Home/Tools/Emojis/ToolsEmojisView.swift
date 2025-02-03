//
//  ToolsEmojisView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 31.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

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
                Text(String(char))
                    .font(.system(size: viewModel.fontSize))
                    .frame(maxWidth: .infinity, minHeight: viewModel.columnWidth, maxHeight: viewModel.columnWidth, alignment: .center)
                    .padding(.paddingDefault)
                    .background(Color.secondaryBackground)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: viewModel.cellCornerRadius))
                    .overlay(
                        ZStack(alignment: .bottomTrailing) {
                            let isSelected = viewModel.selectedEmoji == char
                            RoundedRectangle(cornerRadius: viewModel.cellCornerRadius)
                                .strokeBorder(isSelected ? Color.selectedView : Color.secondaryText, lineWidth: isSelected ? 4 : 1)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.primaryText, Color.selectedView)
                                .font(.title)
                                .padding(.paddingSmall)
                                .opacity(isSelected ? .opacity100 : .opacity0)
                                .animation(.default, value: viewModel.selectedEmoji)
                        }
                    )
                    .onTapGesture {
                        // Handle emoji selection
                        if viewModel.selectedEmoji == char {
                            viewModel.selectedEmoji = nil
                        } else {
                            viewModel.selectedEmoji = char
                        }
                    }
            }
        }
    }
}

#Preview("ToolsEmojisView") {
    ToolsEmojisView()
        .environmentObject(ToolsEmojisViewModel.preview)
}
