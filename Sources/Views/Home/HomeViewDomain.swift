//
//  HomeViewDomain.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 05.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

struct HomeViewDomain: DomainViewConstantType {
    
    typealias Localization = L
    
    typealias Icon = I
    
    var name: String {
        "HomeViewDomain"
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
        static let dragHere: LocalizedStringKey =
        "home.view.drag-and-drop-zone.drag-here"
        
        static let dropHere: LocalizedStringKey =
        "home.view.drag-and-drop-zone.drop-here"
        
        static let choice: LocalizedStringKey =
        "home.view.drag-and-drop-zone.choice"
        
        static let alertPurchaseTitle: LocalizedStringKey =
        "alert.purchase.title"
        
        static let alertPurchaseDescription: LocalizedStringKey =
        "alert.purchase.description"
        
        static let alertPurchaseAction: LocalizedStringKey =
        "alert.purchase.action"
        
        static let alertPurchaseCancel: LocalizedStringKey =
        "alert.purchase.cancel"
    }
    
    enum I: ConstantRawRepresentable {
    }
}
