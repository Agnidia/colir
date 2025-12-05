//
//  View+Debug.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 05.12.2025.
//  Copyright © 2025 IGR Software. All rights reserved.
//


import SwiftUI

extension View {
    
    @ViewBuilder
    static func printDebugInfo() -> some View {
#if DEBUG
        if Log.enabledList[.ui] == true {
            let _ = Self._printChanges()
        }
#endif
    }
}
