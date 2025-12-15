//
//  ShakeModifier.swift
//
//  Created on 08.11.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftUI

/// The Shake struct you’ve provided is a custom GeometryEffect in SwiftUI used to create a shaking animation effect.
/// This effect translates a view horizontally based on a sinusoidal function, creating the appearance of a shake.
struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size _: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: .zero))
    }
}
