//
//  View+Hide.swift
//
//  Created on 01.02.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func isHidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: EmptyView()
        case false: self
        }
    }
}
