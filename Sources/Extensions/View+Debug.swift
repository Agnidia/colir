//
//  View+Debug.swift
//
//  Created on 05.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
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
