//
//  ButtonStyleConstants.swift
//  colir
//
//  Created by Vitalii P on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

enum ButtonStyleConstants {
    static let padding: EdgeInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
    
    static let font: Font = .body
    
    static let cornerRadius: CGFloat = 8
    
    static let textColor: Color = Color.primaryTitleButton
    
    static let textDisableColor: Color = Color.primaryDisabledTitleButton
    
    static let backgroundColor: Color = Color.primaryBackgroundButton
    
    static let backgroundAccentColor: Color = Color.accentBackgroundButton
    
    static let backgroundDisabledColor: Color = Color.primaryDisabledBackgroundButton
    
    static let backgroundHovered: Color = Color.primaryHoveredButton
    
    static let backgroundAccentHovered: Color = Color.accentHoveredButton
}
