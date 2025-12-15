//
//  ColorWheelNSView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import Cocoa

protocol ColorWheelViewDelegate: AnyObject {
    func didChangeColor(hue: Double, saturation: Double, brightness: Double)
}

final class ColorWheelNSView: NSView {
    weak var delegate: ColorWheelViewDelegate?

    let wheelLayer = CALayer()
    let borderLayer = CAShapeLayer()

    // property
    var isContinuous = true
    let scope = NSImageView(image: NSImage(systemSymbolName: "scope", accessibilityDescription: "Color selector")!)

    // Current color state for accessibility
    private var currentHue: Double = 0
    private var currentSaturation: Double = 0
    private var currentBrightness: Double = 1
    let scale: CGFloat = NSScreen.main?.backingScaleFactor ?? 1

    func updateContents(hue: Double, saturation: Double, brightness: Double) {
        // Store current values for accessibility
        currentHue = hue
        currentSaturation = saturation
        currentBrightness = brightness

        // re-draw color wheel
        if wheelLayer.frame.size.width > .zero {
            wheelLayer.contents = createColorWheel(wheelLayer.frame.size, brightness: brightness)
        }

        // update the location of the scope
        let radius = wheelLayer.frame.width / 2
        let x = cos(hue * Double.pi * 2) * saturation * radius + radius
        let y = sin(hue * Double.pi * 2) * saturation * radius + radius
        var rect = scope.frame
        rect.origin = CGPoint(x: x - rect.size.width / 2, y: y - rect.size.height / 2)
        scope.frame = rect
        scope.contentTintColor = .black
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        wantsLayer = true
        allowedTouchTypes = .direct

        layer?.addSublayer(wheelLayer)
        layer?.addSublayer(borderLayer)
        addSubview(scope)
    }

    override func layout() {
        super.layout()

        borderLayer.path = NSBezierPath(ovalIn: CGRect(x: 1, y: 1, width: frame.width - 2, height: frame.height - 2)).cgPath
        borderLayer.fillColor = CGColor.clear
        borderLayer.strokeColor = CGColor(gray: 0.4, alpha: 1.0)
        borderLayer.lineWidth = 1
        wheelLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }

    override var acceptsFirstResponder: Bool {
        return true
    }

    func getIndicatorCoordinate(_ coord: CGPoint) -> (point: CGPoint, isCenter: Bool) {
        // Making sure that the indicator can't get outside the Hue and Saturation wheel

        let dimension: CGFloat = min(wheelLayer.frame.width, wheelLayer.frame.height)
        let radius: CGFloat = dimension / 2
        let wheelLayerCenter = CGPoint(x: wheelLayer.frame.origin.x + radius, y: wheelLayer.frame.origin.y + radius)

        let dx: CGFloat = coord.x - wheelLayerCenter.x
        let dy: CGFloat = coord.y - wheelLayerCenter.y
        let distance: CGFloat = sqrt(dx * dx + dy * dy)
        var outputCoord: CGPoint = coord

        // If the touch coordinate is outside the radius of the wheel, transform it to the edge of the wheel with polar coordinates
        if distance > radius {
            let theta: CGFloat = atan2(dy, dx)
            outputCoord.x = radius * cos(theta) + wheelLayerCenter.x
            outputCoord.y = radius * sin(theta) + wheelLayerCenter.y
        }

        // If the touch coordinate is close to center, focus it to the very center at set the color to white
        let whiteThreshold: CGFloat = 2
        var isCenter = false
        if distance < whiteThreshold {
            outputCoord.x = wheelLayerCenter.x
            outputCoord.y = wheelLayerCenter.y
            isCenter = true
        }
        return (outputCoord, isCenter)
    }

    private func update(event: NSEvent, isContinuous: Bool = false) {
        let dirtyPoint = convert(event.locationInWindow, from: event.window?.contentView)
        let point = CGPoint(x: abs(dirtyPoint.x), y: abs(dirtyPoint.y)) // convert for SwiftUI
        let indicator = getIndicatorCoordinate(point)
        let point2 = indicator.point
        var color = (hue: .zero, saturation: .zero)
        if !indicator.isCenter {
            color = hueSaturationAtPoint(CGPoint(x: point2.x * scale, y: point2.y * scale))
        }

        if isContinuous {
            delegate?.didChangeColor(hue: color.hue, saturation: color.saturation, brightness: 1)
        }
    }

    override func mouseDragged(with event: NSEvent) {
        update(event: event, isContinuous: isContinuous)
    }

    override func mouseUp(with event: NSEvent) {
        update(event: event, isContinuous: true)
    }

    override func mouseDown(with event: NSEvent) {
        update(event: event, isContinuous: isContinuous)
    }

    private func createColorWheel(_ size: CGSize, brightness: Double) -> CGImage {
        // Creates a bitmap of the Hue Saturation wheel
        let originalWidth: CGFloat = size.width
        let originalHeight: CGFloat = size.height
        let dimension: CGFloat = min(originalWidth * scale, originalHeight * scale)
        let bufferLength = Int(dimension * dimension * 4)

        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)
        CFDataSetLength(bitmapData, CFIndex(bufferLength))
        let bitmap = CFDataGetMutableBytePtr(bitmapData)

        for y in stride(from: CGFloat.zero, to: dimension, by: CGFloat(1)) {
            for x in stride(from: CGFloat.zero, to: dimension, by: CGFloat(1)) {
                var hsv: HSV = (hue: .zero, saturation: .zero, brightness: .zero, alpha: .zero)
                var rgb: RGB = (red: .zero, green: .zero, blue: .zero, alpha: .zero)

                let color = hueSaturationAtPoint(CGPoint(x: x, y: y))
                let hue = color.hue
                let saturation = color.saturation
                var a: CGFloat = .zero
                if saturation < 1.0 {
                    // Antialias the edge of the circle.
                    if saturation > 0.99 {
                        a = (1.0 - saturation) * 100
                    } else {
                        a = 1.0
                    }

                    hsv.hue = hue
                    hsv.saturation = saturation
                    hsv.brightness = brightness
                    hsv.alpha = a
                    rgb = hsv2rgb(hsv)
                }
                let offset = Int(4 * (x + (dimension - y - 1) * dimension))
                bitmap?[offset] = UInt8(rgb.red * 255)
                bitmap?[offset + 1] = UInt8(rgb.green * 255)
                bitmap?[offset + 2] = UInt8(rgb.blue * 255)
                bitmap?[offset + 3] = UInt8(rgb.alpha * 255)
            }
        }

        // Convert the bitmap to a CGImage
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let dataProvider: CGDataProvider? = CGDataProvider(data: bitmapData)
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
        let imageRef: CGImage? = CGImage(width: Int(dimension), height: Int(dimension), bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: Int(dimension) * 4, space: colorSpace, bitmapInfo: bitmapInfo, provider: dataProvider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        return imageRef!
    }

    private func hueSaturationAtPoint(_ position: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
        let c = wheelLayer.frame.width * scale / 2
        let dx = CGFloat(position.x - c) / c
        let dy = CGFloat(position.y - c) / c
        let d = sqrt(CGFloat(dx * dx + dy * dy))

        let saturation: CGFloat = d

        var hue: CGFloat
        if d == .zero {
            hue = .zero
        } else {
            hue = atan2(dy, dx) / Double.pi / 2.0
            if hue < .zero {
                hue = hue + 1.0
            }
        }
        return (hue, saturation)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Keyboard Navigation

    override func keyDown(with event: NSEvent) {
        let hueStep = 0.02 // ~7 degrees
        let saturationStep = 0.05

        switch event.keyCode {
        case 123: // Left arrow - decrease hue
            adjustHue(by: -hueStep)
        case 124: // Right arrow - increase hue
            adjustHue(by: hueStep)
        case 125: // Down arrow - decrease saturation
            adjustSaturation(by: -saturationStep)
        case 126: // Up arrow - increase saturation
            adjustSaturation(by: saturationStep)
        case 116: // Page Up - large saturation increase
            adjustSaturation(by: saturationStep * 2)
        case 121: // Page Down - large saturation decrease
            adjustSaturation(by: -saturationStep * 2)
        default:
            super.keyDown(with: event)
        }
    }

    private func adjustHue(by delta: Double) {
        var newHue = currentHue + delta
        if newHue < 0 { newHue += 1.0 }
        if newHue > 1 { newHue -= 1.0 }
        delegate?.didChangeColor(hue: newHue, saturation: currentSaturation, brightness: currentBrightness)
        NSAccessibility.post(element: self, notification: .valueChanged)
    }

    private func adjustSaturation(by delta: Double) {
        let newSaturation = max(0, min(1, currentSaturation + delta))
        delegate?.didChangeColor(hue: currentHue, saturation: newSaturation, brightness: currentBrightness)
        NSAccessibility.post(element: self, notification: .valueChanged)
    }

    #if MEMORY_DEBUG
        deinit {
            print(Self.Type.self)
            print(#function)
        }
    #endif
}

// MARK: - NSAccessibility

extension ColorWheelNSView {
    override func accessibilityRole() -> NSAccessibility.Role? {
        .slider
    }

    override func accessibilityRoleDescription() -> String? {
        "Color wheel"
    }

    override func accessibilityLabel() -> String? {
        "Color picker wheel"
    }

    override func accessibilityValue() -> Any? {
        let hueDegrees = Int(currentHue * 360)
        let saturationPercent = Int(currentSaturation * 100)
        return "Hue \(hueDegrees) degrees, Saturation \(saturationPercent) percent"
    }

    override func accessibilityHelp() -> String? {
        "Use left and right arrow keys to change hue, up and down arrows to adjust saturation"
    }

    override func isAccessibilityElement() -> Bool {
        true
    }
}
