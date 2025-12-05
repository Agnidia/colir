//
//  ButtonStyleConstants.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

enum ButtonStyleConstants {
    static let padding: EdgeInsets = .init(top: .paddingSmall, leading: .paddingDefault, bottom: .paddingSmall, trailing: .paddingDefault)
    
    static let font: Font = .title2
    
    static let cornerRadius: CGFloat = .radiusSmall
    
    static let textColor: Color = Color.primaryTitleButton
    
    static let textDisableColor: Color = Color.primaryDisabledTitleButton
    
    static let backgroundColor: Color = Color.primaryBackgroundButton
    
    static let backgroundDisabledColor: Color = Color.primaryDisabledBackgroundButton
    
    static let backgroundHoveredColor: Color = Color.primaryHoveredButton
    
    static let backgroundAccentHoveredColor: Color = Color.accentHoveredButton
    
    static let backgroundAccentColor: Color = Color.accentBackgroundButton
    
    static let backgroundAppStoreHoveredColor: Color = Color.secondaryHoveredButton
    
    static let backgroundAppStoreColor: Color = Color.secondaryBackgroundButton
}
