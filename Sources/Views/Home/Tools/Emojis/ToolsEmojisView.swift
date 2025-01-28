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
    @EnvironmentObject var model: ToolsEmojisViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ForEach(model.groups, id: \.self) { group in
                    // Check if there are emojis to display for the current group
                    if let emojis = model.emojis[group], emojis.isEmpty == false {
                        DisclosureGroup(
                            isExpanded: Binding<Bool>(
                                get: { model.expanded.contains(group) },
                                set: { isExpanding in
                                    if isExpanding {
                                        model.expanded.insert(group)
                                    } else {
                                        model.expanded.remove(group)
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
                                    if model.expanded.contains(group) {
                                        model.expanded.remove(group)
                                    } else {
                                        model.expanded.insert(group)
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
        LazyVGrid(columns: model.columns(in: geometry), alignment: .leading, spacing: model.viewSettings.spacing) {
            ForEach(emojis, id: \.self) { char in
                Text(String(char))
                    .font(.system(size: model.fontSize))
                    .frame(maxWidth: .infinity, maxHeight: model.columnWidth, alignment: .center)
                    .padding(.paddingDefault)
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: model.cellCornerRadius))
                    .overlay(
                        ZStack(alignment: .bottomTrailing) {
                            let isSelected = model.selectedEmoji == char
                            RoundedRectangle(cornerRadius: model.cellCornerRadius)
                                .strokeBorder(isSelected ? Color.selectedView : Color.clear, lineWidth: 4)
                            Image(systemName: "checkmark.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .font(.title)
                                .padding(model.viewSettings.padding)
                                .opacity(isSelected ? .opacity100 : .opacity0)
                                .animation(.default, value: model.selectedEmoji)
                        }
                    )
                    .onTapGesture {
                        // Handle emoji selection
                        if model.selectedEmoji == char {
                            model.selectedEmoji = nil
                        } else {
                            model.selectedEmoji = char
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
