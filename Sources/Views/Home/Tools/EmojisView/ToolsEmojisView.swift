//
//  ToolsEmojisView.swift
//  colir
//
//  Created by Vitalii P on 31.08.2023.
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
                    DisclosureGroup {
                        LazyVGrid(columns: gridLayout, alignment: .leading, spacing: spacing) {
                            ForEach(model.emojis[group]!, id: \.self) { char in
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
                    }
                }
                .padding(spacing)
            }
        }
    }
}

struct ToolsEmojiesView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsEmojisView()
            .environmentObject(ToolsEmojisViewModel.preview)
    }
}
