//
//  ToolsColorsViewModel.swift
//  colir
//
//  Created by Vitalii P on 18.09.2023.
//

import AppKit

class ToolsColorsViewModel: ObservableObject {
    
    @Published var selectedColor: NSColor? = nil
    
    var colorGroups: [String : [NSColor]] = NSColor.groupsByType
        
    let cellWidth: CGFloat = 128
    let cellHeight: CGFloat = 48
    
    let cellCornerRadius: CGFloat = 8
}

extension ToolsColorsViewModel {
    static var preview: ToolsColorsViewModel {
        ToolsColorsViewModel()
    }
}
