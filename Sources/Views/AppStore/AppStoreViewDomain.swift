//
//  AppStoreViewDomain.swift
//
//  Created on 30.10.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftCommons
import SwiftUI

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
        static let privacyPolicy: LocalizedStringKey =
            "app.store.view.privacy.policy"
        static let termsOfUse: LocalizedStringKey =
            "app.store.view.terms.of.use"
    }

    enum URLs {
        static let privacyPolicy = URL(string: "https://igrsoft.com/info/app/colir/policy.html")!
        static let termsOfUse = URL(string: "https://igrsoft.com/info/app/colir/terms.html")!
    }

    enum I: ConstantRawRepresentable {}
}
