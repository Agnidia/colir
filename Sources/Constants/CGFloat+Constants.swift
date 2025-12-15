//
//  CGFloat+Constants.swift
//
//  Created on 24.02.2024.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Foundation

// This extension adds custom constants for various dimensions and sizes to the CGFloat type.
// These constants are categorized into different sections such as Radius, Grid, TextField, Padding, Spacing, Blur, Opacity, Duration, Size, and Frame for easier readability and usage.

extension CGFloat {
    // MARK: - Radius Constants

    /// Default radius value
    static var radiusDefault: Self { 16 }

    /// Ultra thin radius value
    static var radiusUltraThin: Self { 2 }

    /// Thin radius value
    static var radiusThin: Self { 4 }

    /// Small radius value
    static var radiusSmall: Self { 8 }

    /// Height radius value
    static var radiusBig: Self { 24 }

    /// Height radius value
    static var radiusHeight: Self { 32 }

    /// Large radius value
    static var radiusLarge: Self { 48 }

    // MARK: - Grid Constants

    /// Default grid item size
    static var defaultGridItem: Self { 128 }

    /// Big grid item size
    static var bigGridItem: Self { 256 }

    // MARK: - TextField Constants

    /// TextField height
    static var textFieldHeight: Self { 40 }

    // MARK: - Padding Constants

    /// Default padding
    static var paddingDefault: Self { 16 }

    /// Compact padding
    static var paddingCompact: Self { 12 }

    /// Ultra Thin padding
    static var paddingUltraThin: Self { 2 }

    /// Thin padding
    static var paddingThin: Self { 4 }

    /// Small padding
    static var paddingSmall: Self { 8 }

    /// Big padding
    static var paddingBig: Self { 24 }

    /// Height padding
    static var paddingHeight: Self { 32 }

    /// Large padding
    static var paddingLarge: Self { 48 }

    // MARK: - Spacing Constants

    /// Default spacing
    static var spacingDefault: Self { 8 }

    /// Small spacing
    static var spacingUltraThin: Self { 1 }

    /// Small spacing
    static var spacingThin: Self { 2 }

    /// Small spacing
    static var spacingSmall: Self { 4 }

    /// Big spacing
    static var spacingBig: Self { 12 }

    /// Height spacing
    static var spacingHeight: Self { 16 }

    /// Huge spacing
    static var spacingLarge: Self { 32 }

    // MARK: - Blur Constants

    /// Default blur radius
    static var blurDefault: Self { 16 }

    // MARK: - Opacity Constants

    /// 0% opacity
    static var opacity0: Self { 0.0 }

    /// 10% opacity
    static var opacity10: Self { 0.1 }

    /// 20% opacity
    static var opacity20: Self { 0.2 }

    /// 30% opacity
    static var opacity30: Self { 0.3 }

    /// 40% opacity
    static var opacity40: Self { 0.4 }

    /// 50% opacity
    static var opacity50: Self { 0.5 }

    /// 60% opacity
    static var opacity60: Self { 0.6 }

    /// 70% opacity
    static var opacity70: Self { 0.7 }

    /// 80% opacity
    static var opacity80: Self { 0.8 }

    /// 90% opacity
    static var opacity90: Self { 0.9 }

    /// 99% opacity
    static var opacity99: Self { 0.99 }

    /// 100% opacity
    static var opacity100: Self { 1.0 }

    // MARK: - Duration Constants

    /// Default duration// -- Duration ------------------------------------------

    static var animationDurationDefault: Self { 0.3 }

    static var animationDurationFast: Self { 0.2 }

    static var animationDurationUltraFast: Self { 0.1 }

    static var animationDurationLong: Self { 0.6 }

    // -- Delays --------------------------------------------

    static var updateDelayDefault: Self { animationDurationDefault + 0.005 }

    static var updateDelayShort: Self { animationDurationFast + 0.005 }

    static var updateDelayUltraShort: Self { animationDurationUltraFast + 0.005 }

    static var updateDelayLong: Self { animationDurationDefault + 0.1 }

    static var updateDelayUltraLong: Self { animationDurationDefault * 2 }

    static var updateDelayExtraLong: Self { updateDelayUltraLong * 2 }

    // MARK: - Frame Constants

    /// Frame size related constants
    enum FrameSize {
        enum Icon {
            /// Default icon size
            static var `default`: CGFloat { 32 }

            /// Thin icon size
            static var thin: CGFloat { 8 }

            /// Small icon size
            static var small: CGFloat { 16 }

            /// Big icon size
            static var big: CGFloat { 48 }

            /// Height icon size
            static var height: CGFloat { 64 }

            /// Large icon size
            static var large: CGFloat { 128 }
        }

        enum Button {
            /// Default button size
            static var `default`: CGFloat { 48 }

            /// Small button size
            static var small: CGFloat { 24 }

            /// Big button size
            static var big: CGFloat { 64 }

            /// Large button size
            static var large: CGFloat { 128 }
        }
    }
}
