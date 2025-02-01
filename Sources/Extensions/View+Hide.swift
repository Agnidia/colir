//
//  View+Hide.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 30.01.2025.
//  Copyright © 2025 IGR Software. All rights reserved.
//


import SwiftUI

extension View {
    @ViewBuilder
    func isHidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true:  EmptyView()
        case false: self
        }
    }
}
