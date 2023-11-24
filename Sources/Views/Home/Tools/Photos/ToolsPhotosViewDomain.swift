//
//  ToolsPhotosViewDomain.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

struct ToolsPhotosViewDomain: DomainViewConstantType {
    
    typealias Localization = L
    
    typealias Icon = I
    
    var name: String {
        "ToolsPhotosViewDomain"
    }
    
    var view: CGRect {
        .zero
    }
    
    var padding: EdgeInsets {
        .init(top: 8, leading: 8, bottom: 8, trailing: 8)
    }
    
    var spacing: CGFloat? {
        32
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
        static let photoDescription: LocalizedStringKey =
        "permissions.overlay.open-photo.description"
    }
    
    enum I: ConstantRawRepresentable {
        static let selection: String = "checkmark.circle.fill"
    }
}
