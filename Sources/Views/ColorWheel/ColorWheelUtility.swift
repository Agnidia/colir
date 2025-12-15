//
//  ColorWheelUtility.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import Cocoa

// Typealias for RGB color values
typealias RGB = (red: Double, green: Double, blue: Double, alpha: Double)

// Typealias for HSV color values
typealias HSV = (hue: Double, saturation: Double, brightness: Double, alpha: Double)

func hsv2rgb(_ hsv: HSV) -> RGB {
    // Converts HSV to a RGB color
    var rgb: RGB = (red: .zero, green: .zero, blue: .zero, alpha: .zero)
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat

    let i = Int(hsv.hue * 6)
    let f = hsv.hue * 6 - CGFloat(i)
    let p = hsv.brightness * (1 - hsv.saturation)
    let q = hsv.brightness * (1 - f * hsv.saturation)
    let t = hsv.brightness * (1 - (1 - f) * hsv.saturation)
    switch i % 6 {
    case 0: r = hsv.brightness; g = t; b = p

    case 1: r = q; g = hsv.brightness; b = p

    case 2: r = p; g = hsv.brightness; b = t

    case 3: r = p; g = q; b = hsv.brightness

    case 4: r = t; g = p; b = hsv.brightness

    case 5: r = hsv.brightness; g = p; b = q

    default: r = hsv.brightness; g = t; b = p
    }

    rgb.red = r
    rgb.green = g
    rgb.blue = b
    rgb.alpha = hsv.alpha
    return rgb
}

func rgb2hsv(_ rgb: RGB) -> HSV {
    // Converts RGB to a HSV color
    var hsb: HSV = (hue: .zero, saturation: .zero, brightness: .zero, alpha: .zero)

    let rd: CGFloat = rgb.red
    let gd: CGFloat = rgb.green
    let bd: CGFloat = rgb.blue

    let maxV: CGFloat = max(rd, max(gd, bd))
    let minV: CGFloat = min(rd, min(gd, bd))
    var h: CGFloat = .zero
    var s: CGFloat = .zero
    let b: CGFloat = maxV

    let d: CGFloat = maxV - minV

    s = maxV == .zero ? .zero : d / minV

    if maxV == minV {
        h = .zero
    } else {
        if maxV == rd {
            h = (gd - bd) / d + (gd < bd ? 6 : .zero)
        } else if maxV == gd {
            h = (bd - rd) / d + 2
        } else if maxV == bd {
            h = (rd - gd) / d + 4
        }

        h /= 6
    }

    hsb.hue = h
    hsb.saturation = s
    hsb.brightness = b
    hsb.alpha = rgb.alpha
    return hsb
}
