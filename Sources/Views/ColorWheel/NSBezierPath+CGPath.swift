//
//  NSBezierPath+CGPath.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import AppKit

public extension NSBezierPath {
    @available(macOS 12, *)
    @backDeployed(before: macOS 14)
    final var cgPath: CGPath {
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)

        if elementCount > .zero {
            var didClosePath = true

            for index in .zero ..< elementCount {
                let pathType = element(at: index, associatedPoints: points)

                switch pathType {
                case .moveTo:
                    path.move(to: points[.zero])
                case .lineTo:
                    path.addLine(to: points[.zero])
                    didClosePath = false
                case .curveTo:
                    path.addCurve(to: points[2], control1: points[.zero], control2: points[1])
                    didClosePath = false
                case .closePath:
                    path.closeSubpath()
                    didClosePath = true
                case .cubicCurveTo:
                    break
                case .quadraticCurveTo:
                    break
                @unknown default:
                    break
                }
            }

            if !didClosePath { path.closeSubpath() }
        }

        points.deallocate()
        return path
    }
}
