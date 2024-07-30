//
//  ToolsEmojisViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.09.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

class ToolsEmojisViewModel: ObservableObject, DomainViewConstantProtocol {
    
    typealias DomainViewConstantType = ToolsEmojisViewDomain
    
    let viewSettings: ToolsEmojisViewDomain = .init()
    
    private let emojisManager: EmojisManager = .init()
    
    var groups: [EmojisGroup] = EmojisGroup.allCases
    
    var emojis: [EmojisGroup: [Character]]
    
    @Published var selectedEmoji: Character? = nil
    
    @Published var expanded: Set<EmojisGroup> = []
    
    let columnWidth: CGFloat = 128 // The width for each column
        
    var fontSize: CGFloat {
        columnWidth * 0.6
    }
    
    lazy var cellCornerRadius: CGFloat = viewSettings.cornerRadius!
    
    init(emojis: [EmojisGroup: [Character]]? = nil) {
        self.emojis = emojis ?? emojisManager.emojis
        
        if let firstGroup = self.groups.first {
            self.expanded.insert(firstGroup)
        }
    }
    
    func columns(in geometry: GeometryProxy) -> [GridItem] {
        // Calculate the number of columns dynamically
        let magicWidthOffset = columnWidth * 0.25
        let width = geometry.size.width
        let spacing: CGFloat = viewSettings.spacing ?? .spacingDefault
        
        let columns = Int(width / (columnWidth + magicWidthOffset + spacing))
        let numberOfColumns = (CGFloat(columns) * columnWidth + CGFloat(columns) * spacing) > width ? columns - 1 : columns
        
        let gridLayout = Array(repeating: GridItem(.adaptive(minimum: (columnWidth + magicWidthOffset)), spacing: spacing), count: max(numberOfColumns, 1))
        
        return gridLayout
    }
}

extension ToolsEmojisViewModel {
    static var preview: ToolsEmojisViewModel {
        ToolsEmojisViewModel()
    }
}
