//
//  CGFloat+Constants.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

extension CGFloat {
        
    // -- Radius --------------------------------------------
    static var radiusDefault: Self              { 24 }
    
    static var radiusSmall: Self                { 16 }
    
    static var radiusHeight: Self               { 32 }
    
    static var radiusLarge: Self                { 60 }
    
    static var radiusThin: Self                 { 8 }
    
    // -- Grid ----------------------------------------------

    static var defaultGridItem: Self            { 128 }
    
    // -- TextField -----------------------------------------

    static var textFieldHeight: Self            { 42 }
    
    // -- Padding -------------------------------------------
    
    static var paddingDefault: Self             { 16 }
    
    static var paddingThin: Self                { 4 }
    
    static var paddingSmall: Self               { 8 }
    
    static var paddingHeight: Self              { 24 }
    
    static var paddingLarge: Self               { 32 }
    
    // -- Spacing -------------------------------------------
    
    static var spacingDefault: Self             { 8 }
    
    static var spacingSmall: Self               { 4 }
    
    static var spacingHeight: Self              { 16 }
    
    static var spacingLarge: Self               { 32 }
    
    // -- Opacity --------------------------------------------
    
    static var opacity100: Self                 { 1.0 }
    
    static var opacity0: Self                   { 0.0 }
    
    // -- Animation ------------------------------------------
    
    static var animationDurationDefault: Self   { 0.3 }
    
    static var animationDurationFast: Self      { 0.15 }
    
    static var animationDurationSlow: Self      { 0.5 }
    
    // -- Frame ----------------------------------------------
    
    enum FrameSize {
        static var icon: CGFloat                = 32
        
        static var iconSmall: CGFloat           = 8
        
        static var iconGrid: CGFloat            = 48
    }
    
    // -- View ----------------------------------------------
}
