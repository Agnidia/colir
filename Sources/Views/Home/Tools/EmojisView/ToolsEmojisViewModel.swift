//
//  ToolsEmojisViewModel.swift
//  colir
//
//  Created by Vitalii P on 04.09.2023.
//

import Foundation

class ToolsEmojisViewModel: ObservableObject {
    
    private let emojisManager: EmojisManager = .init()
    
    var groups: [EmojisGroup] = EmojisGroup.allCases
    
    var emojis: [EmojisGroup : [Character]]
    
    let columnWidth: CGFloat = 128 // The width for each column
    
    init(emojis: [EmojisGroup : [Character]]? = nil) {
        self.emojis = emojis ?? emojisManager.emojies
    }
}

extension ToolsEmojisViewModel {
    static var preview: ToolsEmojisViewModel {
        ToolsEmojisViewModel()
    }
}
