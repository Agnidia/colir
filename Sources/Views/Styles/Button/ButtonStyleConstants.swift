//
//  ButtonStyleConstants.swift
//
//  Created on 05.11.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import SwiftUI

enum ButtonStyleConstants {
    static let padding: EdgeInsets = .init(top: .paddingSmall, leading: .paddingDefault, bottom: .paddingSmall, trailing: .paddingDefault)

    static let font: Font = .title2

    static let cornerRadius: CGFloat = .radiusBig

    static let textColor: Color = .primaryTitleButton

    static let textDisableColor: Color = .primaryDisabledTitleButton

    static let backgroundColor: Color = .primaryBackgroundButton

    static let backgroundDisabledColor: Color = .primaryDisabledBackgroundButton

    static let backgroundHoveredColor: Color = .primaryHoveredButton

    static let backgroundAccentHoveredColor: Color = .accentHoveredButton

    static let backgroundAccentColor: Color = .accentBackgroundButton

    static let backgroundAppStoreHoveredColor: Color = .secondaryHoveredButton

    static let backgroundAppStoreColor: Color = .secondaryBackgroundButton
}
