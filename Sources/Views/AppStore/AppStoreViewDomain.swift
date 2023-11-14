//
//  AppStoreViewDomain.swift
//  colir
//
//  Created by Vitalii P on 13.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

struct AppStoreViewDomain: DomainViewConstantType {
    
    typealias Localization = L
    
    typealias Icon = I
    
    var name: String {
        "AppStoreViewDomain"
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
        6
    }
    
    var background: Color {
        .secondaryBackground
    }
    
    enum L: ConstantRawRepresentable {
        static let titleSubscription: LocalizedStringKey =
        "app.store.view.title.subscribe"
        static let titleInAppPurchase: LocalizedStringKey =
        "app.store.view.title.inapp"
    }
    
    enum I: ConstantRawRepresentable {
    }
}
