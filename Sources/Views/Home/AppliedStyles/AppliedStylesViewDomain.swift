//
//  AppliedStylesViewDomain.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftCommons
import SwiftUI

struct AppliedStylesViewDomain: DomainViewConstantType {
    typealias Localization = L

    typealias Icon = I

    var name: String {
        "AppliedStylesViewDomain"
    }

    var view: CGRect {
        .zero
    }

    var padding: EdgeInsets {
        .init(top: .paddingSmall, leading: .paddingSmall, bottom: .paddingSmall, trailing: .paddingSmall)
    }

    var spacing: CGFloat? {
        .spacingHeight
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
        static let customize: LocalizedStringKey =
            "customizing.view.button.customize"
    }

    enum I: ConstantRawRepresentable {}
}
