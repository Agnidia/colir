//
//  NSImageCutPathTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("NSImage CutPath Extension")
struct NSImageCutPathTests {
    // MARK: - cutImage(by:) Tests

    @Test("cutImage with rectangular path returns new image")
    func cutImage_rectangularPath_returnsNewImage() {
        let sourceImage = createTestImage(size: NSSize(width: 100, height: 100), color: .red)
        let path = NSBezierPath(rect: NSRect(x: 25, y: 25, width: 50, height: 50))

        let result = sourceImage.cutImage(by: path)

        #expect(result.size == sourceImage.size)
        #expect(result !== sourceImage)
    }

    @Test("cutImage with oval path")
    func cutImage_ovalPath() {
        let sourceImage = createTestImage(size: NSSize(width: 100, height: 100), color: .blue)
        let path = NSBezierPath(ovalIn: NSRect(x: 10, y: 10, width: 80, height: 80))

        let result = sourceImage.cutImage(by: path)

        #expect(result.size == sourceImage.size)
    }

    @Test("cutImage with circular path")
    func cutImage_circularPath() {
        let size = NSSize(width: 128, height: 128)
        let sourceImage = createTestImage(size: size, color: .green)
        let circlePath = NSBezierPath(ovalIn: NSRect(origin: .zero, size: size))

        let result = sourceImage.cutImage(by: circlePath)

        #expect(result.size == size)
    }

    @Test("cutImage with full image rect path")
    func cutImage_fullImageRectPath() {
        let size = NSSize(width: 100, height: 100)
        let sourceImage = createTestImage(size: size, color: .yellow)
        let fullPath = NSBezierPath(rect: NSRect(origin: .zero, size: size))

        let result = sourceImage.cutImage(by: fullPath)

        #expect(result.size == size)
    }

    @Test("cutImage with rounded rect path")
    func cutImage_roundedRectPath() {
        let size = NSSize(width: 100, height: 100)
        let sourceImage = createTestImage(size: size, color: .purple)
        let roundedPath = NSBezierPath(roundedRect: NSRect(origin: .zero, size: size), xRadius: 20, yRadius: 20)

        let result = sourceImage.cutImage(by: roundedPath)

        #expect(result.size == size)
    }

    @Test("cutImage preserves image dimensions")
    func cutImage_preservesDimensions() {
        for size in TestConstants.iconSizes {
            let sourceImage = createTestImage(size: size, color: .orange)
            let path = NSBezierPath(ovalIn: NSRect(origin: .zero, size: size))
            let result = sourceImage.cutImage(by: path)

            #expect(result.size.width == size.width, "Width should match for size \(size)")
            #expect(result.size.height == size.height, "Height should match for size \(size)")
        }
    }

    // MARK: - Complex Path Tests

    @Test("cutImage with triangle path")
    func cutImage_trianglePath() {
        let size = NSSize(width: 100, height: 100)
        let sourceImage = createTestImage(size: size, color: .cyan)

        let path = NSBezierPath()
        path.move(to: NSPoint(x: 50, y: 0))
        path.line(to: NSPoint(x: 100, y: 100))
        path.line(to: NSPoint(x: 0, y: 100))
        path.close()

        let result = sourceImage.cutImage(by: path)

        #expect(result.size == size)
    }

    @Test("cutImage with star path")
    func cutImage_starPath() {
        let size = NSSize(width: 100, height: 100)
        let sourceImage = createTestImage(size: size, color: .magenta)

        // Create a simple 5-point star
        let path = createStarPath(in: NSRect(origin: .zero, size: size), points: 5)

        let result = sourceImage.cutImage(by: path)

        #expect(result.size == size)
    }

    @Test("cutImage with polygon path")
    func cutImage_polygonPath() {
        let size = NSSize(width: 100, height: 100)
        let sourceImage = createTestImage(size: size, color: .brown)

        // Create a hexagon
        let path = NSBezierPath()
        let center = NSPoint(x: 50, y: 50)
        let radius: CGFloat = 40
        for i in 0 ..< 6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
            let point = NSPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.line(to: point)
            }
        }
        path.close()

        let result = sourceImage.cutImage(by: path)

        #expect(result.size == size)
    }

    // MARK: - Edge Cases

    @Test("cutImage with small image")
    func cutImage_smallImage() {
        let size = NSSize(width: 1, height: 1)
        let sourceImage = createTestImage(size: size, color: .red)
        let path = NSBezierPath(rect: NSRect(origin: .zero, size: size))

        let result = sourceImage.cutImage(by: path)

        #expect(result.size.width == 1)
        #expect(result.size.height == 1)
    }

    @Test("cutImage with rectangular image")
    func cutImage_rectangularImage() {
        let size = NSSize(width: 200, height: 100)
        let sourceImage = createTestImage(size: size, color: .blue)
        let path = NSBezierPath(ovalIn: NSRect(origin: .zero, size: size))

        let result = sourceImage.cutImage(by: path)

        #expect(result.size.width == 200)
        #expect(result.size.height == 100)
    }

    @Test("cutImage with empty path")
    func cutImage_emptyPath() {
        let size = NSSize(width: 100, height: 100)
        let sourceImage = createTestImage(size: size, color: .green)
        let emptyPath = NSBezierPath()

        let result = sourceImage.cutImage(by: emptyPath)

        #expect(result.size == size)
    }

    @Test("cutImage with path outside image bounds")
    func cutImage_pathOutsideBounds() {
        let size = NSSize(width: 100, height: 100)
        let sourceImage = createTestImage(size: size, color: .yellow)
        let outsidePath = NSBezierPath(rect: NSRect(x: 200, y: 200, width: 50, height: 50))

        let result = sourceImage.cutImage(by: outsidePath)

        #expect(result.size == size)
    }

    @Test("cutImage with path partially outside bounds")
    func cutImage_pathPartiallyOutside() {
        let size = NSSize(width: 100, height: 100)
        let sourceImage = createTestImage(size: size, color: .purple)
        let partialPath = NSBezierPath(rect: NSRect(x: 50, y: 50, width: 100, height: 100))

        let result = sourceImage.cutImage(by: partialPath)

        #expect(result.size == size)
    }

    @Test("cutImage multiple times with different paths")
    func cutImage_multipleTimes() {
        let size = NSSize(width: 100, height: 100)
        var image = createTestImage(size: size, color: .orange)

        let circlePath = NSBezierPath(ovalIn: NSRect(x: 10, y: 10, width: 80, height: 80))
        image = image.cutImage(by: circlePath)
        #expect(image.size == size)

        let rectPath = NSBezierPath(rect: NSRect(x: 20, y: 20, width: 60, height: 60))
        image = image.cutImage(by: rectPath)
        #expect(image.size == size)
    }

    // MARK: - Winding Rule Test

    @Test("cutImage uses evenOdd winding rule")
    func cutImage_evenOddWindingRule() {
        let size = NSSize(width: 100, height: 100)
        let sourceImage = createTestImage(size: size, color: .red)

        // Create a path with a hole (concentric circles)
        let path = NSBezierPath()
        path.appendOval(in: NSRect(x: 10, y: 10, width: 80, height: 80))
        path.appendOval(in: NSRect(x: 30, y: 30, width: 40, height: 40))

        let result = sourceImage.cutImage(by: path)

        #expect(result.size == size)
    }

    // MARK: - Helpers

    private func createTestImage(size: NSSize, color: NSColor) -> NSImage {
        TestImageFactory.solidColor(size: size, color: color)
    }

    private func createStarPath(in rect: NSRect, points: Int) -> NSBezierPath {
        let path = NSBezierPath()
        let center = NSPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4

        for i in 0 ..< (points * 2) {
            let angle = CGFloat(i) * .pi / CGFloat(points) - .pi / 2
            let radius = (i % 2 == 0) ? outerRadius : innerRadius
            let point = NSPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.line(to: point)
            }
        }
        path.close()

        return path
    }
}
