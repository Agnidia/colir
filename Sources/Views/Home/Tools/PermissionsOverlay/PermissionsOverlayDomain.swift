//
//  PermissionsOverlayDomain.swift
//
//  Created on 30.10.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftCommons
import SwiftUI

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
        .radiusSmall
    }

    var background: Color {
        .secondaryBackground
    }

    @MainActor
    enum L: ConstantRawRepresentable {
        static let openSettings: LocalizedStringKey =
            "permissions.overlay.open-settings"
    }

    enum I: ConstantRawRepresentable {}
}
