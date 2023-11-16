//
//  ToolsEmojisViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.09.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

class ToolsEmojisViewModel: ObservableObject {
    
    private let emojisManager: EmojisManager = .init()
    
    var groups: [EmojisGroup] = EmojisGroup.allCases
    
    var emojis: [EmojisGroup : [Character]]
    
    @Published var expanded: Set<EmojisGroup> = []
    
    let columnWidth: CGFloat = 128 // The width for each column
    
    init(emojis: [EmojisGroup : [Character]]? = nil) {
        self.emojis = emojis ?? emojisManager.emojis
        
        if let firstGroup = self.groups.first {
            self.expanded.insert(firstGroup)
        }
    }
}

extension ToolsEmojisViewModel {
    static var preview: ToolsEmojisViewModel {
        ToolsEmojisViewModel()
    }
}
