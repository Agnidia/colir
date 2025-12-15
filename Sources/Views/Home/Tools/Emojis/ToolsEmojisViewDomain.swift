//
//  ToolsEmojisViewDomain.swift
//
//  Created on 30.10.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftCommons
import SwiftUI

struct ToolsEmojisViewDomain: DomainViewConstantType {
    typealias Localization = L

    typealias Icon = I

    var name: String {
        "ToolsEmojisViewDomain"
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
