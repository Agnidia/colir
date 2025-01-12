//
//  Double+Constants.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

extension Double {
    
    // -- Radius --------------------------------------------
    static var priorityDefault: Self    { 256 }
    
    static var priorityLow: Self        { 128 }
    
    static var priorityHeight: Self     { 512 }
    
    // -- Opacity --------------------------------------------
    
    static var opacity0: Self           { 0.0 }
    
    static var opacity99: Self          { 0.99 }
    
    static var opacity100: Self         { 1.0 }
    
    // -- Animation ------------------------------------------
    
    static var animationDurationDefault: Self   { 0.3 }
    
    static var animationDurationFast: Self      { 0.15 }
    
    static var animationDurationSlow: Self      { 0.5 }
}
