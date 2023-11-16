//
//  ToolsEmojisView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 31.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct ToolsEmojisView: View {
    
    @EnvironmentObject var model: ToolsEmojisViewModel
    
    var body: some View {
        let spacing: CGFloat = 8
        let magicWidthOffset = model.columnWidth * 0.25
        let fontSize = model.columnWidth * 0.6
        
        GeometryReader { geometry in
            // Calculate the number of columns dynamically
            let width = geometry.size.width
            let columns = Int(width / (model.columnWidth + magicWidthOffset + spacing))
            let numberOfColumns = (CGFloat(columns) * model.columnWidth + CGFloat(columns) * spacing) > width ? columns - 1 : columns
            
            let gridLayout = Array(repeating: GridItem(.fixed(model.columnWidth + magicWidthOffset), spacing: spacing), count: max(numberOfColumns, 1))
            
            ScrollView {
                ForEach(model.groups, id: \.self) { group in
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
                            LazyVGrid(columns: gridLayout, alignment: .leading, spacing: spacing) {
                                ForEach(emojis, id: \.self) { char in
                                    Text(String(char))
                                        .font(.system(size: fontSize))
                                        .frame(width: model.columnWidth, height: model.columnWidth, alignment: .center)
                                        .padding()
                                        .background(Color.accentColor.opacity(0.1))
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        } label: {
                            Text(group.name)
                                .font(.title2)
                                .onTapGesture {
                                    if model.expanded.contains(group) {
                                        model.expanded.remove(group)
                                    } else {
                                        model.expanded.insert(group)
                                    }
                                }
                        }
                    }
                    
                }
                .padding(spacing)
            }
        }
    }
}

#Preview("ToolsEmojisView") {
    ToolsEmojisView()
        .environmentObject(ToolsEmojisViewModel.preview)
}
