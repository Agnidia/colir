//
//  ToolsColorsViewDomain.swift
//  colir
//
//  Created by Vitalii P on 23.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import SwiftUI
import SwiftCommons

struct ToolsColorsViewDomain: DomainViewConstantType {
    typealias Localization = L
    
    typealias Icon = I
    
    var name: String {
        "ToolsColorsViewDomain"
    }
    
    var view: CGRect {
        .zero
    }
    
    var padding: EdgeInsets {
        .init(top: 8, leading: 8, bottom: 8, trailing: 8)
    }
    
    var spacing: CGFloat? {
        16
    }
    
    var border: CGFloat? {
        nil
    }
    
    var borderColor: Color? {
        nil
    }
    
    var cornerRadius: CGFloat? {
        8
    }
    
    var background: Color {
        .secondaryBackground
    }
    
    enum L: ConstantRawRepresentable {
        static let customColor: LocalizedStringKey = "color.tool.view.color-picker.title"
    }
    
    enum I: ConstantRawRepresentable {
        static let selected: String = "checkmark.circle.fill"
    }
}
