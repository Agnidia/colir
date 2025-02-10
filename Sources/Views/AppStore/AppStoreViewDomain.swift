//
//  AppStoreViewDomain.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 13.11.2023.
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
        .init(top: .paddingSmall, leading: .paddingSmall, bottom: .paddingSmall, trailing: .paddingSmall)
    }
    
    var spacing: CGFloat? {
        .spacingDefault
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
    
    @MainActor
    enum L: ConstantRawRepresentable {
        static let titleSubscription: LocalizedStringKey =
        "app.store.view.title.subscribe"
        static let titleInAppPurchase: LocalizedStringKey =
        "app.store.view.title.inapp"
        static let helpRestore: LocalizedStringKey =
        "app.store.view.help.restore"
        static let helpClose: LocalizedStringKey =
        "app.store.view.help.close"
        static let helpInAppPurchase: LocalizedStringKey =
        "app.store.view.help.inapp"
    }
    
    enum I: ConstantRawRepresentable {
    }
}
