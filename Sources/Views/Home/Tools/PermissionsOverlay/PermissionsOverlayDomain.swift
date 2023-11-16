//
//  PermissionsOverlayDomain.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 29.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

struct PermissionsOverlayDomain: DomainViewConstantType {
    
    typealias Localization = L
    
    typealias Icon = I
    
    var name: String {
        "PermissionsOverlayDomain"
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
        6
    }
    
    var background: Color {
        .secondaryBackground
    }
    
    enum L: ConstantRawRepresentable {
        static let openSettings: LocalizedStringKey =
        "permissions.overlay.open-settings"
    }
    
    enum I: ConstantRawRepresentable {
    }
}
