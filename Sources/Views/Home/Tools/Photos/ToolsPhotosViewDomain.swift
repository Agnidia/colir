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
        .init(top: .paddingSmall, leading: .paddingSmall, bottom: .paddingSmall, trailing: .paddingSmall)
    }
    
    var spacing: CGFloat? {
        .spacingLarge
    }
    
    var border: CGFloat? {
        nil
    }
    
    var borderColor: Color? {
        nil
    }
    
    var cornerRadius: CGFloat? {
        .radiusThin
    }
    
    var background: Color {
        .secondaryBackground
    }
    
    @MainActor
    enum L: ConstantRawRepresentable {
        static let photoDescription: LocalizedStringKey =
        "permissions.overlay.open-photo.description"
    }
    
    enum I: ConstantRawRepresentable {
        static let selection: String = "checkmark.circle.fill"
    }
}
